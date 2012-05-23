Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab2EWEuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 00:50:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55807 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2EWEuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 00:50:23 -0400
Date: Wed, 23 May 2012 00:50:23 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tejun@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
Subject: [PATCH] Add human-readable units modifier to vsnprintf()
Message-ID: <20120523045023.GE607@dhcp-172-18-216-138.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
 <20120522211706.GH14339@google.com>
 <20120523031214.GA607@dhcp-172-18-216-138.mtv.corp.google.com>
 <1337744190.13111.33.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337744190.13111.33.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 08:36:30PM -0700, Joe Perches wrote:
> On Tue, 2012-05-22 at 23:12 -0400, Kent Overstreet wrote:
> > On Tue, May 22, 2012 at 02:17:06PM -0700, Tejun Heo wrote:
> []
> > > > +ssize_t hprint(char *buf, int64_t v)
> > > > +{
> > > > +	static const char units[] = "?kMGTPEZY";
> > > > +	char dec[3] = "";
> > > > +	int u, t = 0;
> > > > +
> > > > +	for (u = 0; v >= 1024 || v <= -1024; u++) {
> > > > +		t = v & ~(~0 << 10);
> > > > +		v >>= 10;
> > > > +	}
> > > > +
> > > > +	if (!u)
> > > > +		return sprintf(buf, "%llu", v);
> > > > +
> > > > +	if (v < 100 && v > -100)
> > > > +		sprintf(dec, ".%i", t / 100);
> > > > +
> > > > +	return sprintf(buf, "%lli%s%c", v, dec, units[u]);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(hprint);
> > > 
> > > Not your fault but maybe we want integer vsnprintf modifier for this.
> > 
> > Yes.
> 
> or maybe yet another lib/vsprintf pointer extension
> like %pD with some descriptors after the %pD for
> type, width and precision.

Integer modifier makes more sense to me - it's an integer you're
printing in the first place, anyways...

This code seems to work - it produces the same output as my hprint(),
anyways:

---
 lib/vsprintf.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 38e612e..9225857 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -219,6 +219,7 @@ char *put_dec(char *buf, unsigned long long num)
 #define LEFT	16		/* left justified */
 #define SMALL	32		/* use lowercase in hex (must be 32 == 0x20) */
 #define SPECIAL	64		/* prefix hex with "0x", octal with "0" */
+#define HUNITS	128		/* Human readable units, i.e. k/M/G/T */
 
 enum format_type {
 	FORMAT_TYPE_NONE, /* Just a string part */
@@ -258,6 +259,7 @@ char *number(char *buf, char *end, unsigned long long num,
 {
 	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
 	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
+	static const char units[] = "?kMGTPEZY";
 
 	char tmp[66];
 	char sign;
@@ -310,7 +312,26 @@ char *number(char *buf, char *end, unsigned long long num,
 			num >>= shift;
 		} while (num);
 	} else { /* base 10 */
-		i = put_dec(tmp, num) - tmp;
+		if (spec.flags & HUNITS) {
+			int u, rem = 0;
+
+			for (u = 0; num >= 1024; u++) {
+				rem = num & ~(~0 << 10);
+				num >>= 10;
+			}
+
+			if (u) {
+				tmp[i++] = units[u];
+
+				if (num < 100) {
+					rem /= 100;
+					i = put_dec(tmp + i, rem) - tmp;
+					tmp[i++] = '.';
+				}
+			}
+		}
+
+		i = put_dec(tmp + i, num) - tmp;
 	}
 
 	/* printing 100 using %2d gives "100", not "00" */
@@ -1002,6 +1023,7 @@ int format_decode(const char *fmt, struct printf_spec *spec)
 		case ' ': spec->flags |= SPACE;   break;
 		case '#': spec->flags |= SPECIAL; break;
 		case '0': spec->flags |= ZEROPAD; break;
+		case 'h': spec->flags |= HUNITS;  break;
 		default:  found = false;
 		}
 
-- 
1.7.9.rc2

