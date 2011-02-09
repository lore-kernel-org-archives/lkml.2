Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab1BIJVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:21:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61970 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1BIJVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:21:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=qQuG8V+c8hb0kA2J6vJ4GkJeZf6ko2+/mV6GPPmgziS14DCrt8HypTpAEF3/s4n1nM
         XsywEGsZ8XUDWDUxJQgzvDpOvnSLBCcUG1uvF6iolyo4hs3dwTfaoQqfL2uVloVERb3O
         W/R2Duqkru8vMI3TU9Pmx1sAwdlreGYE2FT0o=
Message-ID: <4D525CA8.60604@suse.cz>
Date: Wed, 09 Feb 2011 10:21:44 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Deegan <Tim.Deegan@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix jiffy calculations in calibrate_delay_direct to	
 handle overflow
References: <4D525EF00200007800030F0F@vpn.id2.novell.com>
In-Reply-To: <4D525EF00200007800030F0F@vpn.id2.novell.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 09:31 AM, Jan Beulich wrote:
> Fixes a hang when booting as dom0 under Xen, when jiffies can be
> quite large by the time the kernel init gets this far.

As I wrote this might happen if the boot till this point takes ~ 5
minutes because we start at -5 minutes.

That said, is this a candidate for stable? (If so, please CC stable.)

> Signed-off-by: Tim Deegan <Tim.Deegan@citrix.com>
> 
> !time_after() -> time_before_eq() as per suggestion from Jiri Slaby.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> 
> ---
>  init/calibrate.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- 2.6.38-rc4/init/calibrate.c
> +++ 2.6.38-rc4-calibrate-jiffy-overflow/init/calibrate.c
> @@ -66,7 +66,7 @@ static unsigned long __cpuinit calibrate
>  		pre_start = 0;
>  		read_current_timer(&start);
>  		start_jiffies = jiffies;
> -		while (jiffies <= (start_jiffies + 1)) {
> +		while (time_before_eq(jiffies, start_jiffies + 1)) {
>  			pre_start = start;
>  			read_current_timer(&start);
>  		}
> @@ -74,8 +74,8 @@ static unsigned long __cpuinit calibrate
>  
>  		pre_end = 0;
>  		end = post_start;
> -		while (jiffies <=
> -		       (start_jiffies + 1 + DELAY_CALIBRATION_TICKS)) {
> +		while (time_before_eq(jiffies, start_jiffies + 1 +
> +					       DELAY_CALIBRATION_TICKS)) {
>  			pre_end = end;
>  			read_current_timer(&end);
>  		}

thanks,
-- 
js
suse labs
