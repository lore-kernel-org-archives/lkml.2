Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2KGAvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 19:51:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2KGAvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 19:51:45 -0500
Date: Tue, 6 Nov 2012 16:51:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: a.zummo@towertech.it, yongjun_wei@trendmicro.com.cn,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: avoid calling platform_device_put() twice in
 test_init()
Message-Id: <20121106165144.bdeca850.akpm@linux-foundation.org>
In-Reply-To: <CAPgLHd-q7WCFrO_hW3nGHPj784jMtR9=fEzMqo5uQKapwO2NUA@mail.gmail.com>
References: <CAPgLHd-q7WCFrO_hW3nGHPj784jMtR9=fEzMqo5uQKapwO2NUA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 13:08:41 +0800
Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function test_init() need to call
> platform_device_del() instead of platform_device_unregister().
> Otherwise, we may call platform_device_put() twice.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/rtc/rtc-test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
> index 7e96254..209a127 100644
> --- a/drivers/rtc/rtc-test.c
> +++ b/drivers/rtc/rtc-test.c
> @@ -164,7 +164,7 @@ static int __init test_init(void)
>  	return 0;
>  
>  exit_device_unregister:
> -	platform_device_unregister(test0);
> +	platform_device_del(test0);
>  
>  exit_free_test1:
>  	platform_device_put(test1);

Is platform_device_del() the partner to platform_device_add()?  If so
then yes, this looks right.  But I think the labels can be improved:

--- a/drivers/rtc/rtc-test.c~rtc-avoid-calling-platform_device_put-twice-in-test_init-fix
+++ a/drivers/rtc/rtc-test.c
@@ -152,24 +152,24 @@ static int __init test_init(void)
 
 	if ((test1 = platform_device_alloc("rtc-test", 1)) == NULL) {
 		err = -ENOMEM;
-		goto exit_free_test0;
+		goto exit_put_test0;
 	}
 
 	if ((err = platform_device_add(test0)))
-		goto exit_free_test1;
+		goto exit_put_test1;
 
 	if ((err = platform_device_add(test1)))
-		goto exit_device_unregister;
+		goto exit_del_test0;
 
 	return 0;
 
-exit_device_unregister:
+exit_del_test0:
 	platform_device_del(test0);
 
-exit_free_test1:
+exit_put_test1:
 	platform_device_put(test1);
 
-exit_free_test0:
+exit_put_test0:
 	platform_device_put(test0);
 
 exit_driver_unregister:
_


However, take a look at test_exit().  it does
platform_device_unregister(test0) when test0 is in the same state.  Is
that code wrong as well?  Presumably it's working OK?

