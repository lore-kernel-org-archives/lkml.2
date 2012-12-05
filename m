Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2LENLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 08:11:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab2LENLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 08:11:07 -0500
Message-ID: <50BF47CA.5070205@redhat.com>
Date: Wed, 05 Dec 2012 11:10:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Federico Vaga <federico.vaga@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 3/4] sta2x11_vip: convert to videobuf2 and control
 framework
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com> <8113379.Pqy1l62Utl@number-5> <50BF315C.8090203@redhat.com> <2637992.xolQO8ly5c@harkonnen>
In-Reply-To: <2637992.xolQO8ly5c@harkonnen>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 05-12-2012 10:24, Federico Vaga escreveu:
> Thank you Mauro for the good explanation
>
>> Yeah, there are many changes there that justifies adding you at its
>> authorship, and that's ok. Also, anyone saying the size of your patch
>> will recognize your and ST efforts to improve the driver.
>>
>> However, as some parts of the code were preserved, dropping the old
>> authors doesn't sound right (and can even be illegal, in the light
>> of the GPL license). It would be ok, though, if you would be
>> changing it to something like:
>>
>> 	Copyright (c) 2010 by ...
>> or
>> 	Original driver from ...
>
> Ok, I understand. I will write something like this.
>   * Copyright (C) 2012       ST Microelectronics
>   *      author: Federico Vaga <federico.vaga@gmail.com>
>   * Copyright (C) 2010       WindRiver Systems, Inc.
>   *      authors: Andreas Kies <andreas.kies@windriver.com>
>   *               Vlad Lungu <vlad.lungu@windriver.com>

Sounds perfect to me.

>> So, IMHO, there's not much point on dropping authorship messages.
>
> So the MODULE_AUTHOR will be Windriver forever until they drop authorship?
> Also if in the next future 0 windriver lines will be in the code?
>
> (general talking, not about this driver)
> If I do git blame on a driver with MODULE_AUTHOR("Mr. X"); but only the
> MODULE_AUTHOR line is from Mr X; there is not an automatically system which
> remove the MODULE_AUTHOR? Ok, probably it was the original author of the code
> and the comment header with the copyright history gives to Mr X all the
> honours, but there is nothing from him in the code. It is not better to remove
> MODULE_AUTHOR or replace it with who wrotes most of the code?
> I know that this is not the best place to talk about this, just a little
> curiosity

As you said, the best place to discuss about it is likely at LKML.
It could make sense to have some policy with regards to MODULE_AUTHOR(),
stating when it could be modified, preferably reviewed by some experienced
open source lawyers. I'm not aware of any.

In any case, I don't think anyone should rely on "git blame" for it.
The tool that helps to get code authorship is "git log -M", but
to get the real authorship requires a lot more of just calling it.

A trivial case where git blame will likely be giving wrong "credits"
is if a driver has all functions reordered. It may happen that git blame
will give credits to the one that reordered the functions, and not to
the original code's author.

There are more subtle cases, though. For example, please assume that
the original driver has to call a certain function to do some needed
work to initialize the device:

	call_function_foo();

And a reviewer latter add a logic to deal with errors, like:

	ret = call_function_foo();
	if (ret)
		return ret;

The reviewer wrote 2 additional lines, and modified 1 original line.
Yet, his contribution didn't make the code to work. The one that did it
was the single-line patch that added call_function_foo(). So, in this
case, a single line change was more significant for the driver than a
3 line addition[1]. Also, again, git blame will give the "credits"
for the line that calls call_function_foo() to the wrong guy.

Btw, this is why it is called "git blame", and not "git authorship":
it is a tool to identify who was the last one that modified the code.
Its main usage is to identify who might have introduced a bug on the
code.

Let's assume that call_function_foo() could be returning some non-error
positive values, under certain circumstances. In that case, the above
code would actually be introducing a bug by using:
	if (ret)
instead of
	if (ret < 0)

So, the 3 line patch is not only be less relevant for the driver to
work than the original author's code, but it is actually wrong
and introduced a serious driver regression, preventing it to work.
Git blame was made to address such cases: once a bug got bisected, it
helps to get the changelog that made the change, pointing to who made
the changes and why. So, a proper fix for the bug can be better
prepared, to not only fix the bug, but to also address the issue
pointed by the blamed patchset.

Regards,
Mauro

[1] Please, don't get be wrong on that: we do want patches adding
proper error handling. They are important to improve the driver's
reliability.
