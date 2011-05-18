Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab1ERPr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:47:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36823 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab1ERPr0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:47:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=sMtDOsJMw4knrU/2sWUhpYJO0a5M7W7S9CFsOVCRsCVJQT+259OinW+PpjubcRRXUM
         Q6DA+c5/TSqGsFguz9vKP4X6btiBDi49yJ5jphImQCBhy7C69RAbZin/dnyt1MN8qyCl
         ZxozGJSHGZNfXzou5A/QGMxtEBQdK7I6Vmiqw=
From: Christian Lamparter <chunkeey@googlemail.com>
To: =?iso-8859-1?q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
Subject: Re: [RFC v2] lis3lv02d: avoid divide by zero due to unchecked register read
Date: Wed, 18 May 2011 17:47:12 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc7-wl+; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201105160046.31019.chunkeey@googlemail.com> <201105162336.05306.chunkeey@googlemail.com> <4DD2EC98.5080901@tremplin-utc.net>
In-Reply-To: <4DD2EC98.5080901@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105181747.12356.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 May 2011 23:46:00 Éric Piel wrote:
> Op 16-05-11 23:36, Christian Lamparter schreef:
> > On Monday 16 May 2011 13:16:46 Éric Piel wrote:
> >> Op 16-05-11 00:46, Christian Lamparter schreef:
> >>>  From my POV, it looks like the hardware is not working as expected
> >>> and returns a bogus data rate. The driver doesn't check the result
> >>> and directly uses it as some sort of divisor in some places:
> >>>
> >>> msleep(lis3->pwron_delay / lis3lv02d_get_odr());
> >>>
> >>> Under this circumstances, this could very well cause the
> >>> "divide by zero" exception from above.
> >>>
> >> However, I'd fix it a bit differently: let lis3lv02d_get_odr() return
> >> the raw data, and create a special function
> >> lis3lv02d_get_pwron_delay_ms() which does the "lis3->pwron_delay /
> >> lis3lv02d_get_odr()" with special handling for 0 (returning a large
> >> value and also sending a printk_once() ).
> > Do you know how "volatile" this data rate is? If it never changes
> > [at least it doesn't here?] then why not read it once in init_device
> > and store it in the device context?
> It is not normally changing, normally it is set just at init/unsuspend 
> (where the bios can also interfere sometimes) and when the user changes 
> it.
Uh, "bios can also interfere"... this sounds very bad. At least for
my x41t the bios doesn't care about hdaps once the OS is running.

> So definitely within the same function it's not going to suddenly 
> change.
a SMM can happen at any time and if a faulty BIOS [likely, since I got
a new laptop] is what caused the crash, I wouldn't bet on "const within
a function context".

> We could avoid calculating/checking it twice in 
> lis3lv02d_selftest(). Care to do a third version with this little clean up?
I have my doubts, but ok if you say so... Just one thing: need to do some Q&A
on the code above, I haven't tested it extensively yet.

Regards,
	Chr
