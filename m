Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1I1Hs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:48:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35420 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1I1HsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:48:25 -0400
MIME-Version: 1.0
In-Reply-To: <1317194947.1998.18.camel@shrek.rexursive.com>
References: <1317183650.2067.10.camel@shrek.rexursive.com>
	<CAOJsxLGam5htmwtTZOuPka02+CZ1Fkv1b+SuYMJ8x9VRntFzRQ@mail.gmail.com>
	<1317194947.1998.18.camel@shrek.rexursive.com>
Date: Wed, 28 Sep 2011 10:48:24 +0300
X-Google-Sender-Auth: ZKKkwn76JImyCi1rmtpPmW2FTfU
Message-ID: <CAOJsxLFGpU53AQRw-nKsz_Lz_QMDP+RDUD5J3bYzbAA_+ngaAA@mail.gmail.com>
Subject: Re: [PATCH v5]: Improve performance of LZO hibernation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bojan Smojver <bojan@rexursive.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 10:29 AM, Bojan Smojver <bojan@rexursive.com> wrote:
> On Wed, 2011-09-28 at 10:22 +0300, Pekka Enberg wrote:
>
>> > +       while(1) {
>> > +               wait_event(d->go, atomic_read(&d->ready) ||
>> > +                                 kthread_should_stop());
>> > +               if (kthread_should_stop())
>> > +                       break;
>>
>> So... what happens to the hibernation process when 'kthread_should_stop()'
>> returns true?
>
> The compression/decompression threads stop by breaking out of the loop.
> At least they should, right? Did I misread some docs here?

Yes, the threads are stopped. What happens after that? Will the
hibernation process be aborted? How can this be tested?

>> What's going on here anyway? Why "num_online_cpus() - 1"? What's wrong with
>>
>>   nr_threads = num_online_cpus();
>>   if (nr_threads > LZO_THREADS)
>>     nr_threads = LZO_THREADS;
>
> We want to keep at least one CPU free for that I/O and for pulling the
> other threads into sync when they are done (that is if we have more than
> one), right?

Well, dunno if it matters much. Did you see performance improvement
with that? Is the CPU binding really needed?

Anyway, if you want to keep the existing behavior, maybe something like

nr_other_cpus = min(1, num_online_cpus()-1);

nr_threads = min(nr_other_cpus, LZO_THREADS);

would do the trick?

                        Pekka
