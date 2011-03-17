Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab1CQRrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:47:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53500 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab1CQRrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:47:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pM4i76KXsdiEbo5hRwwMbLkVgFsnP0keDDSd/94lCzpia1q0/LSWZP9HX5E2PiGZMA
         Dw5uEP08lMIcDjJh9O19WV8eaEnh80L441OG3br8/9V+1GhVhVO1cevHocwIeS6XHaaF
         4IQaCASNW/IAnNIQA5co51VdhmGV4wOfi/IB0=
MIME-Version: 1.0
In-Reply-To: <1300381340.6315.323.camel@edumazet-laptop>
References: <AANLkTi=e+tM-WTerLmkZfLTQqKCLsJHVBgQ5sj+TMjc4@mail.gmail.com>
	<1300370936.16880.96.camel@gandalf.stny.rr.com>
	<AANLkTi=Z_yYkdwzO7TMs7nSMOXR9wn_7BxtKjOKgS5HL@mail.gmail.com>
	<1300380909.16880.264.camel@gandalf.stny.rr.com>
	<1300381340.6315.323.camel@edumazet-laptop>
Date: Thu, 17 Mar 2011 18:43:05 +0100
X-Google-Sender-Auth: gSYew6l-ATD7lQN7YhFjfHQIfH8
Message-ID: <AANLkTik6oHOOk+1paSmCs=0c03_J10wGBFrRMQw-Jo86@mail.gmail.com>
Subject: Re: um: WARNING: at kernel/futex.c:786 __unqueue_futex
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        laijs@cn.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net, dvhart@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 18:02, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 17 mars 2011 à 12:55 -0400, Steven Rostedt a écrit :
>> Here, test this patch. I'm in the process of committing it now.
>> It will be two patches, one for the WARN_ON_SMP() change, the other for
>> the futex change.
>>
>> -- Steve
>>
>> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
>> index c2c9ba0..25f1e9e 100644
>> --- a/include/asm-generic/bug.h
>> +++ b/include/asm-generic/bug.h
>> @@ -168,7 +168,7 @@ extern void warn_slowpath_null(const char *file, const int line);
>>  #ifdef CONFIG_SMP
>>  # define WARN_ON_SMP(x)                      WARN_ON(x)
>>  #else
>> -# define WARN_ON_SMP(x)                      do { } while (0)
>> +# define WARN_ON_SMP(x)                      ({0;})
>>  #endif
>>
>
> You meant :
>
> # define WARN_ON_SMP(x)                 ({x;})
>
> or
>
> # define WARN_ON_SMP(x)   do { } while (x, 0)
>
> ?

I don't know. It's not clear to me if "WARN_ON_SMP(x)" should always return "x",
or only on SMP?

E.g.

    if (WARN_ON_SMP(x)) {
       // Should we get here if "x" is true?
       // Or only if CONFIG_SMP and "x" are both true?
    }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
