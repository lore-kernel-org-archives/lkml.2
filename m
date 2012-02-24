Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab2BXR6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:58:37 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:64798 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754719Ab2BXR6g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:58:36 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dwindsor@gmail.com designates 10.182.147.106 as permitted sender) smtp.mail=dwindsor@gmail.com; dkim=pass header.i=dwindsor@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120218161849.GA4176@kroah.com>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
	<20120216204515.GH20420@outflux.net>
	<20120217002405.GB7746@kroah.com>
	<20120217075945.GA2831@albatros>
	<20120217175445.GC29902@kroah.com>
	<20120217193719.GA4187@albatros>
	<20120217233908.GA24047@dztty>
	<CAL1RGDWM0C26YR+GGbguRQd0R3HoPJ5QVyEFkLGFfPqs6wb5Mg@mail.gmail.com>
	<20120218161849.GA4176@kroah.com>
Date: Fri, 24 Feb 2012 12:58:35 -0500
Message-ID: <CAEXv5_jYj=cHsePJEf4f08KsBOfU+MVMnV0DucmVKQbg+KbxrQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
From: David Windsor <dwindsor@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Roland Dreier <roland@purestorage.com>, Djalal Harouni <tixxdz@opendz.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>,
        Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, pageexec@freemail.hu,
        spender@grsecurity.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>

>> Greg, I'm not sure why you're opposed to adding this checking...
>> it's pretty clear that buggy error paths that forget to do a put are
>> pretty common and will continue to be common in new code, and
>> making them harder to exploit seems pretty sane to me.
>>
>> What's the downside?
>
> The downside is that there has not even been a patch sent for any of
> this.  Combine that with a lack of understanding about reference
> counting and atomic_t usages in the kernel, and the whole thing is ripe
> for misunderstanding and confusion.
>
> greg k-h

This approach to adding overflow protection to kref uses
atomic_add_unless to increment the refcounter only if it is not
already at INT_MAX.  This
leaks the internal representation of atomic_t, which is defined as an
int in linux/types.h, into kref.

If we can agree on an approach to adding overflow protection, if it is
indeed desired, we can then discuss adding a Kconfig option and/or a
sysctl for this protection.

Thanks,
David


Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 include/linux/kref.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 9c07dce..fc0756a 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -38,8 +38,12 @@ static inline void kref_init(struct kref *kref)
  */
 static inline void kref_get(struct kref *kref)
 {
+   int rc = 0;
    WARN_ON(!atomic_read(&kref->refcount));
-   atomic_inc(&kref->refcount);
+   smp_mb__before_atomic_inc();
+   rc = atomic_add_unless(&kref->refcount, 1, INT_MAX);
+   smp_mb__after_atomic_inc();
+   BUG_ON(!rc);
 }

 /**
-- 
1.7.5.4


-- 
PGP: 6141 5FFD 11AE 9844 153E  F268 7C98 7268 6B19 6CC9
