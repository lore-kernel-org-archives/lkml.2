Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1LLJLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:11:09 -0500
Received: from ozlabs.org ([203.10.76.45]:42172 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab1LLJLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:11:02 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com,
        Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH 21/21] MODSIGN: Apply signature checking to modules on module load [ver #3]
In-Reply-To: <26644.1323652900@redhat.com>
References: <87obvfogc6.fsf@rustcorp.com.au> <8739csq5ac.fsf@rustcorp.com.au> <87boriouwa.fsf@rustcorp.com.au> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184651.21874.57769.stgit@warthog.procyon.org.uk> <2657.1323456206@redhat.com> <30007.1323526114@redhat.com> <26644.1323652900@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 12 Dec 2011 19:39:34 +1030
Message-ID: <87ty56taup.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011 01:21:40 +0000, David Howells <dhowells@redhat.com> wrote:
> Rusty Russell <rusty@ozlabs.org> wrote:
> 
> > I think you misunderstand, I'm talking about the modinfo command, not
> > the .modinfo section.
> 
> Sorry, yes.  But why do you need to enhance modinfo?

I was suggesting that you want it to print the signatures, or at least
indicate their existence.  Maybe check them too, but that might be a bit
too heavy for modinfo.

> > But I need to know exactly what these version-dependent mangling of
> > modules is.  Is it real?  Is it more than strip?  Is it so hard to fix
> > that it makes sense to add 450 lines of dense kernel code to allow
> > alteration of a module after signing?
> 
> The strip program (as far as I know that's the only binutil that we need worry
> about) rearranges and reorders the section, symbol and relocation tables when
> it discards stuff, and different versions of strip have done it
> differently.

OK, then you need to generate stripped modules as part of the build,
too.  It's a bit of a pain, sure, but hardly a showstopper.

> However, you said it should be fairly easy to jump over the ELF parcel to get
> to the signature.  How do you plan on doing that?

> I presume you would just parse sufficient of the ELF to find the
> theoretical ELF EOF and then look there for a whole string of
> signatures

You could do that.  But there's an easier way.  Took me longer to figure
out the damn crypto API than actually write the module part :(

Subject: module: simple signature support.

A signature contains a magic marker: it signs everything up to the
magic marker (ie. just append them):
	SUM=`md5sum drivers/block/loop.ko | cut -d\  -f1`; echo "@Module signature:$SUM" >> drivers/block/loop.ko

We can have false positives, but at worst that make us report EINVAL
(bad signature) instead of ENOENT (no signature).

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2374,6 +2374,98 @@ free_hdr:
 	return err;
 }
 
+/* CONFIG_MODULE_SIGN implies we don't trust modules: verify signature
+ * before we interpret (almost) anything. */
+#define MOD_SIGNATURE "@Module signature:"
+
+#include <linux/ctype.h>
+#include <crypto/hash.h>
+#include <crypto/md5.h>
+
+static int from_hex(char c)
+{
+	if (isdigit(c))
+		return c - '0';
+	if (isupper(c))
+		return c - 'A' + 10;
+	return c - 'a' + 10;
+}
+
+/* A signature signs everything before it. */
+static int try_signature(void *data, void *sig, unsigned long max_sig)
+{
+	unsigned long data_len = sig - data;
+
+	sig += strlen(MOD_SIGNATURE);
+	max_sig -= strlen(MOD_SIGNATURE);
+
+	/* Dummy: accept md5 as signature. */
+	{
+		struct crypto_api_blows {
+			struct shash_desc md5;
+			char morestuff[100];
+		} m;
+		u8 digest[MD5_DIGEST_SIZE], expected[MD5_DIGEST_SIZE];
+		char *s = sig;
+		int i;
+
+		/* Not a signature? */
+		if (max_sig < MD5_DIGEST_SIZE * 2) {
+			printk("Too close to end (%lu)\n", max_sig);
+			return -ENOENT;
+		}
+
+		for (i = 0; i < MD5_DIGEST_SIZE * 2; i += 2) {
+			/* Not a signature? */
+			if (!isxdigit(s[i]) || !isxdigit(s[i+1])) {
+				printk("Not hex digit (%c)\n", s[i]);
+				return -ENOENT;
+			}
+			digest[i/2] = (from_hex(s[i])<<4) | from_hex(s[i+1]);
+		}
+
+		m.md5.tfm = crypto_alloc_shash("md5", 0, 0);
+		if (IS_ERR(m.md5.tfm))
+			return PTR_ERR(m.md5.tfm);
+		m.md5.flags = 0;
+
+		crypto_shash_digest(&m.md5, data, data_len, expected);
+		crypto_free_shash(m.md5.tfm);
+		
+		if (memcmp(digest, expected, sizeof(digest)) != 0) {
+			printk("Mismatch: given %02x%02x%02x...,"
+			       " expect %02x%02x%02x...\n",
+			       digest[0], digest[1], digest[2],
+			       expected[0], expected[1], expected[2]);
+			return -EINVAL;
+		}
+		printk("Found valid signature!\n");
+		return 0;
+	}
+}
+
+/* -ENOENT if no signature found, -EINVAL if invalid, 0 if good. */
+static int find_and_check_signatures(struct load_info *info)
+{
+	void *p = info->hdr, *end = p + info->len;
+	const size_t sigsize = strlen(MOD_SIGNATURE);
+	int err = -ENOENT;
+
+	/* Poor man's memmem. len > sigsize */
+	while ((p = memchr(p, MOD_SIGNATURE[0], end - p))) {
+		if (p + sigsize > end)
+			break;
+
+		if (memcmp(p, MOD_SIGNATURE, sigsize) == 0) {
+			err = try_signature(info->hdr, p, end - p);
+			if (!err)
+				break;
+		}
+		p++;
+	}
+	return err;
+}
+
 static void free_copy(struct load_info *info)
 {
 	vfree(info->hdr);
@@ -2819,6 +2911,11 @@ static struct module *load_module(void _
 	if (err)
 		return ERR_PTR(err);
 
+	/* Before we trust it, carefully check signatures. */
+	err = find_and_check_signatures(&info);
+	if (err)
+		goto free_copy;
+
 	/* Figure out module layout, and allocate all the memory. */
 	mod = layout_and_allocate(&info);
 	if (IS_ERR(mod)) {


