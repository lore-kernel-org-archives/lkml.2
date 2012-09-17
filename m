Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab2IQOzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:55:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49091 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502Ab2IQOzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:55:48 -0400
Message-ID: <505739EF.5010000@gmail.com>
Date: Mon, 17 Sep 2012 08:55:43 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>, acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, tzanussi@gmail.com
Subject: Re: perf script: rwtop: SIGALRM and pipe read race
References: <20120914153952.GA8834@turtle.usersys.redhat.com> <505355AF.7000006@gmail.com> <20120914181049.GA16618@turtle.usersys.redhat.com>
In-Reply-To: <20120914181049.GA16618@turtle.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/12 12:10 PM, Andrew Jones wrote:
> On Fri, Sep 14, 2012 at 10:05:03AM -0600, David Ahern wrote:
>> On 9/14/12 9:39 AM, Andrew Jones wrote:
>>>
>>> I recently tried 'perf script rwtop', and it immediately failed with
>>> 'failed to read event header'. Running it through strace I found that the
>>> when rwtop.pl is reading from the pipe, and gets one of it's alarms, that
>>> the ERESTARTSYS seems to confuse it - causing it to fail. It also appears
>>> that the problem only happens early in execution, or not at all. If I get
>>> lucky and don't hit the problem right away, then rwtop will run fine as
>>> long as I want, without any ERESTARTSYS's in its trace. I also found that
>>> I can avoid hitting the problem by throwing a 'pv -q' in front of the perf
>>> command in tools/perf/scripts/perl/bin/rwtop-report. Which I guess slows
>>> things down in the reader enough to always avoid the race.
>>>
>>> Sorry I don't have a solution (patch). I'll look at it more as time
>>> permits, but I thought I'd get it reported for starters though.
>>
>>
>> This fixes the run-time problem:
>>
>> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
>> index 1b8775c..a4371ae 100644
>> --- a/tools/perf/util/util.c
>> +++ b/tools/perf/util/util.c
>> @@ -142,6 +142,9 @@ int readn(int fd, void *buf, size_t n)
>>      while (n) {
>>          int ret = read(fd, buf, n);
>>
>> +        if ((ret < 0) && (errno == EINTR))
>> +            continue;
>> +
>>          if (ret <= 0)
>>              return ret;
>>
>>
>>
>> The only problem you will find with rwtop is that bytes_read will be
>> really whacky. I traced it to:
>>
>>      if ($ret > 0) {
>> printf("comm %s bytes_read %d\n", $common_comm, $ret);
>>          $reads{$common_pid}{bytes_read} += $ret;
>>
>> Somehow the $ret > 0 is passing when in fact it is negative. I do
>> not know much about perl to fix it.
>>
>
> This actually appears to be an issue with how perl sighandlers are
> supposed to work.
>
> http://perldoc.perl.org/perlipc.html#Restartable-system-calls
>
> I tried the below patch though, and while it gets me past the read failure
> it still doesn't solve the problem. With it the script stops processing
> events after the first one.
>
> Drew
>
> diff --git a/tools/perf/scripts/perl/rwtop.pl
> b/tools/perf/scripts/perl/rwtop.pl
> index 4bb3ecd..8b20787 100644
> --- a/tools/perf/scripts/perl/rwtop.pl
> +++ b/tools/perf/scripts/perl/rwtop.pl
> @@ -17,6 +17,7 @@ use lib
> "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/l
>   use lib "./Perf-Trace-Util/lib";
>   use Perf::Trace::Core;
>   use Perf::Trace::Util;
> +use POSIX qw/SIGALRM SA_RESTART/;
>
>   my $default_interval = 3;
>   my $nlines = 20;
> @@ -90,7 +91,10 @@ sub syscalls::sys_enter_write
>
>   sub trace_begin
>   {
> -    $SIG{ALRM} = \&set_print_pending;
> +    my $sa = POSIX::SigAction->new(\&set_print_pending);
> +    $sa->flags(SA_RESTART);
> +    $sa->safe(1);
> +    POSIX::sigaction(SIGALRM, $sa) or die "Can't set SIGALRM handler:
> $!\n";
>       alarm 1;
>   }
>
> Drew
>

Not sure why you want to change the signal handling. The display routine 
appears to be working.

Arnaldo had pinged me about rwtop a couple of weeks ago -- thinking one 
of my patches broke it. After looking into it I see 3 problems with the 
rwtop scripts:

1. readn can fail with EINTR and that needs to be handled. The earlier 
patch fixes that.

2. the rwtop.pl script is not handling negative return values ($ret < 0) 
properly -- the '$ret > 0' check is succeeding even though $ret is 
negative (e.g., -EAGAIN) leading to astronomical read values

3. record by default uses the watermark so it does not push records to 
the report script until the watermark is reached. This has 2 side effects:

a. for systems doing few reads and writes it can take a while for enough 
records to be generated causing an apparent hang when the command is 
launched. disabling delay (-D argument to perf-record in rwtop-record) 
handles that, but that's not the right answer for busy systems.

b. the display will not be accurate (up to date) given that there are 
buffered records that have not been processed.

Really we need a periodic mode for record that would push all records 
every N timer interval. This way everything is pushed to the processing 
script in a timely manner.

Arnaldo: I believe 3 explains the hang you saw.

David
