Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab1BGIpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 03:45:19 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59879 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1BGIpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 03:45:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qWS7oJe34uJ9S3DSgXZZpitIgDjIBZ1X4JOBeBnLXNdzlpWBJ+LXzbkgvh4byalZZv
         9jSXc+O8CBuCyCyxn1Ecyp5x3Tw/Q+TmZ1FloFLgcqzRkfS1sX5/ejbxz0kCQ8TcDOyp
         HM/vxmGYtc7PjSQ5ERnrxAjYhhx/2DMEZb+x4=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=KGMJ9vLaLfkzGQrc-F2eB5CRmDX1L5UohPTZ=@mail.gmail.com>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
	<s5hfws1whq8.wl%tiwai@suse.de>
	<AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com>
	<AANLkTikE_Oa=HGhW3zpc_rdeBvOWckpZ6dfFWq=JnL9R@mail.gmail.com>
	<849307$bf0dak@azsmga001.ch.intel.com>
	<AANLkTi=Z1fCA1N47YaCh1tn=PCAAboWtNCUyUH-N3yUo@mail.gmail.com>
	<AANLkTik0eJVr1S5=bCO8kmkwCxYzLE_kh9C3ccpn+mWX@mail.gmail.com>
	<s5hy65suu7t.wl%tiwai@suse.de>
	<AANLkTi=KGMJ9vLaLfkzGQrc-F2eB5CRmDX1L5UohPTZ=@mail.gmail.com>
Date: Mon, 7 Feb 2011 16:45:16 +0800
Message-ID: <AANLkTimW_V96w4USjxX1=8_r6g-XJzdcGbYn_JDr9ANL@mail.gmail.com>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 4:36 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Mon, Feb 7, 2011 at 4:25 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> At Mon, 7 Feb 2011 13:02:46 +0800,
>> Jeff Chua wrote:
>>>
>>> On Mon, Feb 7, 2011 at 12:48 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>>> > On Sun, Feb 6, 2011 at 11:27 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>> >> One last step: move contents of intel_crtc_reset() back to
>>> >> intel_crtc_init() one by one.
>>> >>
>>> >> The active flag is my suspicion. I was thinking that we brought up the
>>> >> outputs in a similar manner upon resume as upon initial boot. On
>>> >> reflection, this is the not case.
>>> >>
>>> >> However, the first action we take inside modesetting is to disable the
>>> >> outputs about to be reconfigured. So setting active should be the right
>>> >> course of action so that cleanup any residual state from resume.
>>> >>
>>> >> So I am intrigued as to which line is the cause, and just where the
>>> >> machine becomes unresponsive...
>>> >
>>> > It's this line causing the problem.
>>> >
>>> > intel_crtc->active = true; /* force the pipe off on setup_init_config */
>>> >
>>> >
>>> > When it's called before entering intel_crtc_reset(&intel_crtc->base),
>>> > it works, but if called within the function, it doesn't work. Strange.
>>> > Not sure whether is passing the correct value to to_intel_crtc(crtc)?
>>>
>>> I've added printk() below and the function returns a different value
>>> of intel_crtc.
>>>
>>>
>>> static void intel_crtc_reset(struct drm_crtc *crtc)
>>> {
>>>         struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
>>>         printk("intel_crtc %p\n", intel_crtc); ===> intel_crtc ffff8802349d1000
>>>
>>> }
>>>
>>> printk("intel_crtc %p\n", intel_crtc); ===> intel_crtc ffff8802349d0000
>>> intel_crtc_reset(&intel_crtc->base);
>>
>> That's weird.  Since base is the first member, both intel_crtc and crtc
>> must be identical.
>
> In case I'm messing something up, here's my intel_display.c

Why not just pass intel_crtc as in

- static void intel_crtc_reset(struct drm_crtc *crtc)
+ static void intel_crtc_reset(struct intel_crtc *intel_crtc)

Jeff.
