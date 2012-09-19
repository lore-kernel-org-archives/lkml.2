Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab2ISFHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 01:07:44 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:41472 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754536Ab2ISFHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 01:07:43 -0400
From: Feng Hong <hongfeng@marvell.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 18 Sep 2012 22:07:04 -0700
Subject: RE: [PATCH] poweroff: fix bug in orderly_poweroff
Thread-Topic: [PATCH] poweroff: fix bug in orderly_poweroff
Thread-Index: Ac2WIcWGqZhbRxezTKyH/JKTtMPdIQAARJWg
Message-ID: <E62404B31D39064FBDD0B843ADF05A7D2D395FC749@SC-VEXCH4.marvell.com>
References: <1348025233-13412-1-git-send-email-hongfeng@marvell.com>
 <87fw6eaac4.fsf@xmission.com>
In-Reply-To: <87fw6eaac4.fsf@xmission.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8J582CR028908

Hi, Eric

1. We are developing on an Android phone platform, we use thermal framework to monitor the temperature, when the temperature above like 110 degree, thermal framework will use orderly_shutdown to shutdown phone, however, on Android platform there is no " /sbin/poweroff " cmd ready . Then we want "fail ret" to trigger force shutdown (use kernel_power_off), but always we get "suc ret"
2. Here the caller just wait for "poweroff" userspace application, if it block the called, then it's the "poweroff" problem itself
3. As in the original orderly_shutdown design, we must get the right "ret", if this ret is always "0", then it obey orderly_poweroff design goal. Step 2: force shutdown is always useless code. 
int orderly_poweroff(bool force)
{
        int ret = __orderly_poweroff();

        if (ret && force) {
                printk(KERN_WARNING "Failed to start orderly shutdown: "
                       "forcing the issue\n");

                /*
                 * I guess this should try to kick off some daemon to sync and
                 * poweroff asap.  Or not even bother syncing if we're doing an
                 * emergency shutdown?
                 */
                emergency_sync();
                kernel_power_off();
        }

        return ret;
}1
--
Best Regards,
Feng Hong
Application Processor Software Engnieer 
Marvell Technology (Shanghai) Ltd


-----Original Message-----
From: Eric W. Biederman [mailto:ebiederm@xmission.com] 
Sent: 2012Äê9ÔÂ19ÈÕ 12:47
To: Feng Hong
Cc: akpm@linux-foundation.org; gorcunov@openvz.org; keescook@chromium.org; serge.hallyn@canonical.com; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] poweroff: fix bug in orderly_poweroff

hongfeng <hongfeng@marvell.com> writes:

> orderly_poweroff is trying to poweroff platform by two steps:
> step 1: Call userspace application to poweroff
> step 2: If userspace poweroff fail, then do a force power off if force param is set.
>
> The bug here is, step 1 is always successful with param UMH_NO_WAIT,

This code has existed for 5 years.  Is this a recent regression?  Why
has no one complained before?

It looks to me that step 2 is:
step 2: If we can not launch the userspace poweroff fail.

> should change to UMH_WAIT_PROC which will monitor the return value
> ofuserspace application.

Is it safe to block indefinitely in the callers waiting for userspace?

If the caller is not running in a kernel thread then we can easily get
into a case where the userspace caller will block waiting for us when we
are waiting for the userspace caller.

I don't want to impeded progress but I don't see the evidence that this
change is good enough.


> Change-Id: I2f9ebbb90c0c2443780080ec9507c8d004e5da74
> Signed-off-by: Feng Hong <hongfeng@marvell.com>
> ---
>  kernel/sys.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 241507f..1b30b30 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2204,7 +2204,7 @@ static int __orderly_poweroff(void)
>  		return -ENOMEM;
>  	}
>  
> -	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
> +	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_WAIT_PROC,
>  				      NULL, argv_cleanup, NULL);
>  	if (ret == -ENOMEM)
>  		argv_free(argv);
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
