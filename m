Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379Ab0GVRdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 13:33:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759118Ab0GVRdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 13:33:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/6] DNS: Implement option parsing on dns_resolver results
To: smfrench@gmail.com, jlayton@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wang Lei <wang840925@gmail.com>, David Howells <dhowells@redhat.com>
Date: Thu, 22 Jul 2010 18:33:11 +0100
Message-ID: <20100722173311.1512.10569.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100722173251.1512.29858.stgit@warthog.procyon.org.uk>
References: <20100722173251.1512.29858.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Lei <wang840925@gmail.com>

When the dns_resolver upcall program packages results and instantiates its key
with them, the offered data may have a number of options appended to it.  Each
option is of the form:

	#key=value

This implements an option by which the key's expiry time can be set from the
DNS TTL datum:

	#expiry=<nnn>

where <nnn> is a time_t value.

Signed-off-by: Wang Lei <wang840925@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/dns_resolver/dns_key.c |   85 ++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 78 insertions(+), 7 deletions(-)

diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index 1b1b411..02c7336 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -42,6 +42,8 @@ MODULE_PARM_DESC(debug, "DNS Resolver debugging mask");
 
 const struct cred *dns_resolver_cache;
 
+#define	DNS_EXPIRY_OPTION	"expiry_time"
+
 /*
  * Instantiate a user defined key for dns_resolver.
  *
@@ -50,17 +52,26 @@ const struct cred *dns_resolver_cache;
  *
  * If the data contains a '#' characters, then we take the clause after each
  * one to be an option of the form 'key=value'.  The actual data of interest is
- * the string leading up to the first '#'.  For instance:
+ * the string leading up to the first '#'.
+ *
+ * The only option currently supported is the expiry time of the key, which can
+ * be set from the TTL field of the DNS record.  The value should be a time_t
+ * time.
+ *
+ * For instance:
+ *
+ *        "ip1,ip2,...#expiry_time=123"
  *
- *        "ip1,ip2,...#foo=bar"
+ * the expiry time of the data is 123 and the data starts after '#'.
  */
 static int
 dns_resolver_instantiate(struct key *key, const void *_data, size_t datalen)
 {
 	struct user_key_payload *upayload;
+	unsigned long expiry = 0;
 	int ret;
 	size_t result_len = 0;
-	const char *data = _data, *opt;
+	const char *data = _data, *end, *opt;
 
 	kenter("%%%d,%s,'%s',%zu",
 	       key->serial, key->description, data, datalen);
@@ -70,13 +81,65 @@ dns_resolver_instantiate(struct key *key, const void *_data, size_t datalen)
 	datalen--;
 
 	/* deal with any options embedded in the data */
-	opt = memchr(data, '#', datalen);
+	end = data + datalen - 1;
+	opt = memchr(data, '#', datalen - 1);
 	if (!opt) {
-		kdebug("no options currently supported");
-		return -EINVAL;
+		/* no options: the entire data is the result */
+		kdebug("no options");
+		result_len = datalen - 1;
+	} else {
+		result_len = opt - data;
+		opt++;
+		kdebug("options: '%s'", opt);
+		do {
+			const char *next_opt, *eq;
+			int opt_len, opt_nlen, opt_vlen, tmp;
+
+			next_opt = memchr(opt, '#', end - opt) ?: end;
+			opt_len = next_opt - opt;
+			if (!opt_len) {
+				printk(KERN_WARNING
+				       "Empty option to dnsresolver key %d\n",
+				       key->serial);
+				return -EINVAL;
+			}
+
+			eq = memchr(opt, '=', opt_len) ?: end;
+			opt_nlen = eq - opt;
+			eq++;
+			opt_vlen = next_opt - eq; /* will be -1 if no value */
+
+			tmp = opt_vlen >= 0 ? opt_vlen : 0;
+			kdebug("option '%*.*s' val '%*.*s'",
+			       opt_nlen, opt_nlen, opt, tmp, tmp, eq);
+
+			/* see if it's the expiry time */
+			if (opt_nlen == sizeof(DNS_EXPIRY_OPTION) - 1 &&
+			    memcmp(opt, DNS_EXPIRY_OPTION, opt_nlen) == 0) {
+				kdebug("expiry time option");
+				if (opt_vlen <= 0)
+					goto bad_option_value;
+
+				ret = strict_strtoul(eq, 10, &expiry);
+				if (ret < 0)
+					goto bad_option_value;
+				kdebug("expiry time = %lu", expiry);
+				goto next_option;
+			}
+
+		bad_option_value:
+			printk(KERN_WARNING
+			       "Option '%*.*s' to dnsresolver key %d:"
+			       " bad/missing value\n",
+			       opt_nlen, opt_nlen, opt, key->serial);
+			return -EINVAL;
+
+		next_option:
+			opt = next_opt + 1;
+		} while (opt < end);
 	}
 
-	result_len = datalen;
+	kdebug("store result");
 	ret = key_payload_reserve(key, result_len);
 	if (ret < 0)
 		return -EINVAL;
@@ -87,11 +150,19 @@ dns_resolver_instantiate(struct key *key, const void *_data, size_t datalen)
 		return -ENOMEM;
 	}
 
+	/* attach the data */
 	upayload->datalen = result_len;
 	memcpy(upayload->data, data, result_len);
 	upayload->data[result_len] = '\0';
 	rcu_assign_pointer(key->payload.data, upayload);
 
+	/* if we were given an expiry time, then try to apply it */
+	kdebug("expiry %lu [%lu]", expiry, key->expiry);
+	if (expiry && (key->expiry == 0 || expiry < key->expiry)) {
+		kdebug("set expiry to %ld hence", expiry - get_seconds());
+		key->expiry = expiry;
+	}
+
 	kleave(" = 0");
 	return 0;
 }

