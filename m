Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2EHIEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 04:04:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35927 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab2EHIDG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 04:03:06 -0400
MIME-Version: 1.0
In-Reply-To: <4FA8D046.7000808@gmail.com>
References: <20120501132409.GA22894@lizard>
	<20120501132620.GC24226@lizard>
	<4FA35A85.4070804@kernel.org>
	<20120504073810.GA25175@lizard>
	<CAOJsxLH_7mMMe+2DvUxBW1i5nbUfkbfRE3iEhLQV9F_MM7=eiw@mail.gmail.com>
	<CAHGf_=qcGfuG1g15SdE0SDxiuhCyVN025pQB+sQNuNba4Q4jcA@mail.gmail.com>
	<20120507121527.GA19526@lizard>
	<4FA82056.2070706@gmail.com>
	<CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com>
	<CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com>
	<CAOJsxLFAavdDbiLnYRwe+QiuEHSD62+Sz6LJTk+c3J9gnLVQ_w@mail.gmail.com>
	<CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com>
	<CAOJsxLG1+zhOKgi2Rg1eSoXSCU8QGvHVED_EefOOLP-6JbMDkg@mail.gmail.com>
	<4FA8D046.7000808@gmail.com>
Date: Tue, 8 May 2012 11:03:05 +0300
X-Google-Sender-Auth: LX5mz4NUht3WQsL6MvaSrUOYAVc
Message-ID: <CAOJsxLGWtJy7q6ij_-tN8nVTr-OXpgdWVkXsOda8S9mJzo7n2w@mail.gmail.com>
Subject: Re: [PATCH 3/3] vmevent: Implement special low-memory attribute
From: Pekka Enberg <penberg@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Minchan Kim <minchan@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 10:50 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
>>> 1) sample_period is brain damaged idea. If people ONLY need to
>>> sampling stastics, they
>>>  only need to read /proc/vmstat periodically. just remove it and
>>> implement push notification.
>>>  _IF_ someone need unfrequent level trigger, just use
>>> "usleep(timeout); read(vmevent_fd)"
>>>  on userland code.
>>
>> That comes from a real-world requirement. See Leonid's email on the topic:
>>
>> https://lkml.org/lkml/2012/5/2/42
>
> I know, many embedded guys prefer such timer interval. I also have an
> experience
> similar logic when I was TV box developer. but I must disagree. Someone hope
> timer housekeeping complexity into kernel. but I haven't seen any
> justification.

Leonid?

>>> 6) Also vmevent_event must hide from userland.
>>
>> Why? That's part of the ABI.
>
> Ahhh, if so, I missed something. as far as I look, vmevent_fd() only depend
> on vmevent_config. which syscall depend on vmevent_evennt?

read(2). See tools/testing/vmevent/vmevent-test.c for an example how
the ABI is used.

>>> 7) vmevent_config::size must be removed. In 20th century, M$ API
>>> prefer to use this technique. But
>>>  They dropped the way because a lot of application don't initialize
>>> size member and they can't use it for keeping upper compitibility.
>>
>> It's there to support forward/backward ABI compatibility like perf
>> does. I'm going to keep it for now but I'm open to dropping it when
>> the ABI is more mature.
>
> perf api is not intended to use from generic applications. then, I don't
> think it will make abi issue. tool/perf is sane, isn't it? but vmevent_fd()
> is generic api and we can't trust all userland guy have sane, unfortunately.

The perf ABI is being used by other projects as well. We don't
_depend_ on ->size being sane as much as use it to detect new features
in the future.

But anyway, we can consider dropping once the ABI is more stable.

> Hm. If you want vmevent makes depend on CONFIG_EMBEDDED, I have no reason to
> complain this feature. At that world, almost all applications _know_ their
> system configuration. then I don't think api misuse issue is big matter.

No, I don't want to do that. I was just commeting on why existing
solutions are the way they are.
