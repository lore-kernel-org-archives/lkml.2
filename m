Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0CQQFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:05:08 -0400
Received: from mail.perches.com ([173.55.12.10]:1739 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab0CQQFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:05:05 -0400
Subject: [PATCH] wireless.h: Add STD_IW_HANDLER macro
From: Joe Perches <joe@perches.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Andy Whitcroft <apw@canonical.com>, gregkh@suse.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1268840454.1999.22.camel@localhost>
References: <1268823629.1999.9.camel@localhost>
	 <1268839535.1652.43.camel@Joe-Laptop.home>
	 <1268840454.1999.22.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 09:05:04 -0700
Message-ID: <1268841904.1652.94.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 15:40 +0000, Richard Kennedy wrote:
> On Wed, 2010-03-17 at 08:25 -0700, Joe Perches wrote:
> > On Wed, 2010-03-17 at 11:00 +0000, Richard Kennedy wrote:
> > > I'm getting this error from checkpatch which is a false positive AFAICT.
> > > I don't see any other way to code this macro so maybe this rule
> > > shouldn't apply?.
> > > 	ERROR: space prohibited before open square bracket '['
> > > 	#24: FILE: drivers/staging/wlan-ng/p80211wext.c:1685:
> > > 	+#define IW_IOCTL(x) [(x)-SIOCSIWCOMMIT]
> > While true that this is a false positive, hiding array indexing
> > brackets in a macro doesn't seem a good idea.
> > Maybe it'd be better to move the brackets to the use?
> err maybe ;)
> I copied it from driver/net/wireless/ipw2x00/ipw2200.c 
> It just reduces typing when initialising the array :-
> 	#define IW_IOCTL(x) [(x)-SIOCSIWCOMMIT]
> 	static iw_handler p80211wext_handlers[] = {
> 		IW_IOCTL(SIOCSIWCOMMIT) = (iw_handler) p80211wext_siwcommit,
> 		...
> Oh, having quickly looked at wireless.h, I see there is already a macro
> IW_IOCTL_IDX so I guess I should have used that!
> would something like this be better?
> 	static iw_handler p80211wext_handlers[] = {
> 		[IW_IOCTL_IDX(SIOCSIWCOMMIT)] = (iw_handler) p80211wext_siwcommit,
> 		...

orinoco uses one more macro indirection which seems reasonable

Maybe this define should be moved to wireless.h

#define STD_IW_HANDLER(id, func) \
	[IW_IOCTL_IDX(id)] = (iw_handler) func

the line continued macro probably avoids checkpatch warnings too...

orinoco use:

static const iw_handler	orinoco_handler[] = {
	STD_IW_HANDLER(SIOCSIWCOMMIT,	orinoco_ioctl_commit),
	STD_IW_HANDLER(SIOCGIWNAME,	cfg80211_wext_giwname),

Here's a suggested patch:

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 5b4c6c7..ad9f8d5 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -346,6 +346,8 @@
 #define SIOCIWFIRST	0x8B00
 #define SIOCIWLAST	SIOCIWLASTPRIV		/* 0x8BFF */
 #define IW_IOCTL_IDX(cmd)	((cmd) - SIOCIWFIRST)
+#define STD_IW_HANDLER(id, func) \
+	[IW_IOCTL_IDX(id)] = (iw_handler) func
 
 /* Odd : get (world access), even : set (root access) */
 #define IW_IS_SET(cmd)	(!((cmd) & 0x1))


