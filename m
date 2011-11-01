Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab1KAEOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 00:14:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52181 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab1KAEOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 00:14:52 -0400
MIME-Version: 1.0
In-Reply-To: <20111031115817.GA20448@khazad-dum.debian.net>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
 <20111030212644.GA7106@khazad-dum.debian.net> <815860869.50724.1320011477430.JavaMail.mail@webmail17>
 <20111031091607.GB7106@khazad-dum.debian.net> <574299906.69412.1320054001912.JavaMail.mail@webmail05>
 <20111031115817.GA20448@khazad-dum.debian.net>
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Date: Tue, 1 Nov 2011 12:14:30 +0800
Message-ID: <CAC8teKWo=d8bb1h0aM9XDOkFGARXEO1sVg5+=1+2Pe4ap83u5g@mail.gmail.com>
Subject: Re: HT (Hyper Threading) aware process scheduling doesn't work as it should
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I think the unbalance has got much better on mainline kernel than OS
vendor's, i.e. RHEL6.  Just in case you are interested, below is a
very simple test case I used before against NUMA + CFS group
scheduling extension. I have tested this on a dual-soket Xeon E5620
server.

cat bbb.c
int main()
{
    while(1)
    {
    };
}



cat run.sh

#!/bin/sh
count=0
pids=" "
while [ $count -lt 32 ]
do
	mkdir /cgroup/$count
	echo 1024 > /cgroup/$count/cpu.shares
	# taskset -c 4,5,6,7,12,13,14,15 ./bbb &
	./bbb &
	pid=`echo $!`
	echo $pid > /cgroup/$count/tasks
	pids=`echo $pids" "$pid`
	count=`expr $count + 1`
done
echo "for pid in $pids;do cat /proc/$pid/sched|grep
sum_exec_runtime;done" > show.sh
watch -n1 sh show.sh


Since one e5620 with HT enabled has 8 logical cpus, this dual-socket
box has 16 logical cpus in total. The above test script starts 32
processes, so the intuitively guess is each two of them will run on
one logical cpu. However it's not for current RHEL6 kernel, top shows
that they are keeping migrating and often unbalanced, sometimes worse
and sometimes better. If you watch it for a long time, you may find
sometimes one process occupy the whole logical cpu for a moment, and
several process (far more than 2) congest on a single cpu slot.
Also the 'watch' output shows that the sum_exec_runtime is almost the
same of them, so it seems that the RHEL6 kernel is trying to move a
lucky guy to a free cpu slot, make it hold that position for a while,
then move the next lucky guy there and kick off the previous one to a
crowded slot, which is not a good policy for such totally Independent
processes.
And on the mainline kernel(3.0.0+), they run much more balanced that
above, although I can't identify which commits made this.

--
Regards,
Zhu Yanhai


2011/10/31 Henrique de Moraes Holschuh <hmh@hmh.eng.br>:
> On Mon, 31 Oct 2011, Artem S. Tashkinov wrote:
>> > On Oct 31, 2011, Henrique de Moraes Holschuh  wrote:
>> >
>> > On Sun, 30 Oct 2011, Artem S. Tashkinov wrote:
>> > > > Please make sure both are set to 0.  If they were not 0 at the time you
>> > > > ran your tests, please retest and report back.
>> > >
>> > > That's 0 & 0 for me.
>> >
>> > How idle is your system during the test?
>>
>> load average: 0.00, 0.00, 0.00
>
> I believe cpuidle will interfere with the scheduling in that case.  Could
> you run your test with higher loads (start with one, and go up to eight
> tasks that are CPU-hogs, measuring each step)?
>
>> I have to insist that people conduct this test on their own without trusting my
>> words. Probably there's something I overlook or don't fully understand but from
>
> What you should attempt to do is to give us a reproducible test case.  A
> shell script or C/perl/python/whatever program that when run clearly shows
> the problem you're complaining about on your system.  Failing that, a very
> detailed description (read: step by step) of how you're testing things.
>
> I can't see anything wrong in my X5550 workstation (4 cores, 8 threads,
> single processor, i.e. not NUMA) running 3.0.8.
>
>> what I see, there's a serious issue here (at least Microsoft XP and 7 work exactly
>
> So far it looks like that, since your system is almost entirely idle, it
> could be trying to minimize task-run latency by scheduling work to the few
> cores/threads that are not in deep sleep (they take time to wake up, are
> often cache-cold, etc).
>
> Please use tools/power/x86/turbostat to track core usage and idle-states
> instead of top/htop.  That might give you better information, and I
> think you will appreciate getting to know that tool.  Note: turbostat
> reports *averages* for each thread.
>
> --
>  "One disk to rule them all, One disk to find them. One disk to bring
>  them all and in the darkness grind them. In the Land of Redmond
>  where the shadows lie." -- The Silicon Valley Tarot
>  Henrique Holschuh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
