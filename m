Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab2JVWfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:35:37 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:52959 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JVWfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:35:36 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2012 18:35:36 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id
	:subject:from:to:cc:date:in-reply-to:references:content-type
	:content-transfer-encoding:mime-version; q=dns; s=sasl; b=f8ecUF
	HuXCGMqeMB+CoPmrxURuJQ+nbZJStiff5lQKtIsLFTPoetWWp3B0j8HFlz0/8HCx
	KWNDXHiUOHCo39kIji5FbctBaT3t/taiN41y7QCSEZtA24goiTErq5v9cEREjIq9
	FuhdRRJ66E9/gbhQVjmmXPDt4lk9BA87IP9b4=
Message-ID: <1350944894.19698.208.camel@doorstop.aus.2wire.com>
Subject: Re: [PATCH] ledtrig-cpu: use spin_lock to replace mutex lock
From: Nathan Lynch <ntl@pobox.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Miles Lane <miles.lane@gmail.com>,
        akpm <akpm@linux-foundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
Date: Mon, 22 Oct 2012 17:28:14 -0500
In-Reply-To: <CAK5ve-JAc2Env1AyZMY178QobhqmAh4euHQdPS=UH3mGGeSgLA@mail.gmail.com>
References: <CAK5ve-JAc2Env1AyZMY178QobhqmAh4euHQdPS=UH3mGGeSgLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Pobox-Relay-ID: C5B463F8-1C97-11E2-B270-DB5E0E5B5709-04752483!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Thu, 2012-10-18 at 11:18 -0700, Bryan Wu wrote:
> @@ -117,14 +117,14 @@ static int __init ledtrig_cpu_init(void)
>  	for_each_possible_cpu(cpu) {
>  		struct led_trigger_cpu *trig = &per_cpu(cpu_trig, cpu);
> 
> -		mutex_init(&trig->lock);
> +		spin_lock_init(&trig->lock);
> 
>  		snprintf(trig->name, MAX_NAME_LEN, "cpu%d", cpu);
> 
> -		mutex_lock(&trig->lock);
> +		spin_lock(&trig->lock);
>  		led_trigger_register_simple(trig->name, &trig->_trig);
>  		trig->lock_is_inited = 1;
> -		mutex_unlock(&trig->lock);
> +		spin_unlock(&trig->lock);

I wouldn't know how to fix the original problem, but I don't think this
patch is okay -- led_trigger_register_simple() does things that
potentially sleep (GFP_KERNEL allocation, down_write), so it's not safe
to call while holding a spinlock.


