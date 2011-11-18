Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1KRLLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:11:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab1KRLLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:11:46 -0500
Date: Fri, 18 Nov 2011 11:11:40 +0000
From: Mel Gorman <mgorman@suse.de>
To: Dave Jones <davej@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Re: long sleep_on_page delays writing to slow storage
Message-ID: <20111118111140.GA20840@suse.de>
References: <20111107045928.GK8927@hexapodia.org>
 <20111109170027.GB7495@quack.suse.cz>
 <20111109175201.GB3083@suse.de>
 <20111109180646.GM5075@redhat.com>
 <20111110093442.GG3153@redhat.com>
 <20111114184717.GA7006@redhat.com>
 <20111115101313.GA28350@suse.de>
 <20111117194719.GA23213@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20111117194719.GA23213@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline

On Thu, Nov 17, 2011 at 02:47:20PM -0500, Dave Jones wrote:
> On Tue, Nov 15, 2011 at 10:13:13AM +0000, Mel Gorman wrote:
>  
>  > If they are still experiencing major stalls, I have an experimental
>  > script that may be able to capture stack traces of processes stalled
>  > for more than 1 second. I've had some success with it locally so
>  > maybe they could try it out to identify if it's THP or something else.
>  
> I'm not sure if it's the same problem, but I'd be interested in trying
> that script.
> 

Monitor script is attached as watch-dstate.pl. Run it as

watch-dstate.pl -o logfile

I'm also attaching a post-processing script stap-dstate-frequency.

cat logfile | stap-dstate-frequency

will report on unique stack traces, what got stuck in them and
for how long. Unfortunately, this does require a working systemtap
installation because it had to work on systems without ftrace. Usually
systemtap is a case of installing debugging symbols and its package
but milage varies.

I ran this for a few days on my own desktop but found that the worst
stalls for firefox and evolution were in futex_wait with the second
worst in

[<ffffffffa018e3c5>] ext4_sync_file+0x225/0x290 [ext4]
[<ffffffff81178250>] do_fsync+0x50/0x80
[<ffffffff8117852e>] sys_fdatasync+0xe/0x20
[<ffffffff81448592>] system_call_fastpath+0x16/0x1b

The stall timing is approximate at best. If you find the stall figures
are way too high or unrealistic, try running with --accurate-stall. The
stall figures will be much more accurate but depending on your
kernel version, the stack traces may be one line long ending with
kretprobe_trampoline.

> When I build a kernel on my laptop, when it gets to the final link stage,
> and there's a ton of IO, my entire X session wedges for a few seconds.
> This may be unrelated, because this is on an SSD, which shouldn't suffer
> from the slow IO of the USB devices mentioned in this thread.
> 

I have a vague suspicion that there are some interactivity issues
around SSDs but I don't know why that is. I'm basing this on some
complaints of audio skipping with heavy kernel compiles on machines
very similar to my own other than mine uses rotary storage. It's on
the Christmas list to by myself a SSD to take a closer look.

> (This is even with that patch applied btw, perhaps adding further fuel to
> the idea that it's unrelated).
> 

I suspect it's not compaction related in that case but the script may be
able to tell for sure. If it does not catch anything, alter this line to
have a smaller threshold

global stall_threshold = 1000

-- 
Mel Gorman
SUSE Labs

--45Z9DzgjV8m4Oswq
Content-Type: application/x-perl
Content-Disposition: attachment; filename="watch-dstate.pl"
Content-Transfer-Encoding: quoted-printable

#!/usr/bin/perl=0A# This script is a combined perl and systemtap script to =
collect information=0A# on a system stalling in writeback. Ordinarily, one =
would expect that all=0A# information be collected in a STAP script. Unfort=
unately, in practice the=0A# stack unwinder in systemtap may not work with =
a current kernel version,=0A# have trouble collecting all the data necessar=
y or some other oddities.=0A# Hence this hack. A systemtap script is run an=
d as it records interesting=0A# events, the remaining information is collec=
ted from the script. This means=0A# that the data is *never* exact but can =
be better than nothing and easier=0A# than a fully manual check=0A#=0A# Cop=
yright Mel Gorman <mgorman@suse.de> 2011=0A=0Ause File::Temp qw/mkstemp/;=
=0Ause File::Find;=0Ause FindBin qw($Bin);=0Ause Getopt::Long;=0Ause strict=
;=0A=0Amy @trace_functions =3D (=0A	"get_request_wait",=0A	"wait_for_comple=
tion",=0A	"wait_on_page_bit",=0A	"try_to_free_pages",=0A	"shrink_zone");=0A=
=0Amy @completion_functions=3D(=0A	"handle_mm_fault",=0A	"sys_select",=0A	"=
__wake_up",=0A	"wake_up_bit",=0A	"__alloc_pages_nodemask",=0A	"balance_pgda=
t",=0A	"kmem_cache_alloc");=0A=0Amy @trace_conditional =3D (=0A	"sync_page"=
,=0A	"sync_buffer",=0A	"sleep_on_buffer",=0A	"sleep_on_page",=0A	"sleep_on_=
buffer",=0A	"try_to_compact_pages",=0A	"balance_dirty_pages_ratelimited_nr"=
,=0A	"balance_dirty_pages");=0A=0A# Information on each stall is gathered a=
nd stored in a hash table for=0A# dumping later. Define some constants for =
the table lookup to avoid=0A# blinding headaches=0Ause constant VMSTAT_AT_S=
TALL       =3D> 0;=0Ause constant VMSTAT_AT_COMPLETE    =3D> 1;=0Ause const=
ant BLOCKSTAT_AT_STALL    =3D> 2;=0Ause constant BLOCKSTAT_AT_COMPLETE =3D>=
 3;=0Ause constant PROCNAME              =3D> 4;=0Ause constant STACKTRACE =
           =3D> 5;=0Ause constant STALLFUNCTION         =3D> 6;=0A=0Ause co=
nstant NR_WRITEBACK =3D> 0;=0Ause constant NR_DIRTY     =3D> 2;=0Ause const=
ant VMSCAN_WRITE =3D> 1;=0A=0Asub usage() {=0A	print("In general, this scri=
pt is not supported and that includes help.\n");=0A	exit(0);=0A}=0A=0A# Opt=
ion variables=0Amy $opt_help;=0Amy $opt_output;=0Amy $opt_stapout;=0Amy $op=
t_accurate_stall;=0AGetOptions(=0A	'help|h'		=3D> \$opt_help,=0A	'output|o=
=3Ds'		=3D> \$opt_output,=0A	'stapout|s=3Ds'		=3D> \$opt_stapout,=0A	'accur=
ate-stall|a'	=3D> \$opt_accurate_stall,=0A);=0A=0Ausage() if $opt_help;=0Ai=
f ($opt_output) {=0A	open(OUTPUT, ">$opt_output") || die("Failed to open $o=
pt_output for writing");=0A}=0Aif ($opt_stapout) {=0A	open(OUTPUT, ">$opt_s=
tapout") || die("Failed to open $opt_stapout for writing");=0A}=0A=0A# Hand=
le cleanup of temp files=0Amy $stappid;=0Amy ($handle, $stapscript) =3D mks=
temp("/tmp/stapdXXXXX");=0Asub cleanup {=0A	if (defined($stappid)) {=0A		ki=
ll INT =3D> $stappid;=0A	}=0A	if (defined($opt_output)) {=0A		close(OUTPUT)=
;=0A	}=0A	unlink($stapscript);=0A}=0Asub sigint_handler {=0A	close(STAP);=
=0A	cleanup();=0A	exit(0);=0A}=0A$SIG{INT} =3D "sigint_handler";=0A=0A# Bui=
ld a list of stat files to read. Obviously this is not great if device=0A# =
hotplug occurs but that is not expected for the moment and this is lighter=
=0A# than running find every time=0Amy @block_iostat_files;=0Asub d {=0A	my=
 $file =3D $File::Find::name;=0A	return if $file eq "/sys/block";=0A	push(@=
block_iostat_files, "$file/stat");=0A}=0Afind(\&d, ("/sys/block/"));=0A=0A#=
#=0A# Read the current stack of a given pid=0Asub read_stacktrace($) {=0A	o=
pen(STACK, "/proc/$_[0]/stack") || return "Stack unavailable";=0A	my $stack=
 =3D do {=0A		local $/;=0A		<STACK>;=0A	};=0A	close(STACK);=0A	return $stac=
k;=0A}=0A=0A##=0A# Read information of relevant from /proc/vmstat=0Asub rea=
d_vmstat {=0A	if (!open(VMSTAT, "/proc/vmstat")) {=0A		cleanup();=0A		die("=
Failed to read /proc/vmstat");=0A	}=0A=0A	my $vmstat;=0A	my ($key, $value);=
=0A	my @values;=0A	while (!eof(VMSTAT)) {=0A		$vmstat =3D <VMSTAT>;=0A		($k=
ey, $value) =3D split(/\s+/, $vmstat);=0A		chomp($value);=0A=0A		if ($key e=
q "nr_writeback") {=0A			$values[NR_WRITEBACK] =3D $value;=0A		}=0A		if ($k=
ey eq "nr_dirty") {=0A			$values[NR_DIRTY] =3D $value;=0A		}=0A		if ($key e=
q "nr_vmscan_write") {=0A			$values[VMSCAN_WRITE] =3D $value;=0A		}=0A	}=0A=
=0A	return \@values;=0A}=0A=0A##=0A# Read information from all /sys/block s=
tat files=0Asub read_blockstat($) {=0A	my $prefix =3D $_[0];=0A	my $stat;=
=0A	my $ret;=0A	=0A	foreach $stat (@block_iostat_files) {=0A		if (open(STAT=
, $stat)) {=0A			$ret .=3D sprintf "%s%20s %s", $prefix, $stat, <STAT>;=0A	=
		close(STAT);=0A		}=0A	}=0A	return $ret;=0A}=0A=0A##=0A# Record a line of =
output=0Asub log_output {=0A	if (defined($opt_output)) {=0A		print OUTPUT @=
_;=0A	}=0A	print @_;=0A}=0A=0Asub log_printf {=0A	if (defined($opt_output))=
 {=0A		printf OUTPUT @_;=0A	}=0A	printf @_;=0A}=0A=0Asub log_stap {=0A	if (=
defined($opt_stapout)) {=0A		print OUTPUT @_;=0A	}=0A}=0A=0A# Read kernel s=
ymbols and add conditional trace functions if they exist=0Aopen(KALLSYMS, "=
/proc/kallsyms") || die("Failed to open /proc/kallsyms");=0Awhile (<KALLSYM=
S>) {=0A	my ($dummy, $dummy, $symbol) =3D split(/\s+/, $_);=0A	my $conditio=
nal;=0A	foreach $conditional (@trace_conditional) {=0A		if ($symbol eq $con=
ditional) {=0A			push(@trace_functions, $symbol);=0A			last;=0A		}=0A	}=0A}=
=0Aclose(KALLSYMS);=0A=0A# Extract the framework script and fill in the res=
t=0Aopen(SELF, "$0") || die("Failed to open running script");=0Awhile (<SEL=
F>) {=0A	chomp($_);=0A	if ($_ ne "__END__") {=0A		next;=0A	}=0A	while (<SEL=
F>) {=0A		print $handle $_;=0A	}=0A}=0Aforeach(@trace_functions) {=0A	print=
 $handle "probe kernel.function(\"$_\").call=0A{ =0A	t=3Dtid()=0A	name[t]=
=3Dexecname()=0A	stalled_at[t]=3Dtime()=0A	where[t]=3D\"$_\"=0A	delete stal=
led[t]=0A}";=0A}=0A=0Aif ($opt_accurate_stall) {=0A	# In an ideal world, we=
 would always use a retprobe to catch exactly when=0A	# the function exited=
 and get a stall time from it. Unfortunately, it mangles=0A	# the stack tra=
ce so we have the option of either accurately tracking stalls=0A	# or accur=
ately tracking stacks=0A	foreach(@trace_functions) {=0A		print $handle "pro=
be kernel.function(\"$_\").return=0A{=0A	t=3Dtid()=0A=0A	if ([t] in stalled=
) {=0A		stall_time =3D time() - stalled_at[t]=0A		printf(\"C %d (%s) %d %s =
%s\\n\", t, name[t], stall_time, time_units, where[t])=0A	}=0A=0A	delete st=
alled[t]=0A	delete name[t]=0A	delete stalled_at[t]=0A	delete where[t]=0A}"=
=0A	}=0A} else {=0A	# Alternatively, we try to catch when a stall completes=
 by probing=0A	# commonly used functions and guessing that when they are ca=
lled=0A	# that the operation completed=0A	foreach(@completion_functions) {=
=0A		print $handle "probe kernel.function(\"$_\")=0A{=0A	t=3Dtid()=0A=0A	if=
 ([t] in stalled) {=0A		stall_time =3D time() - stalled_at[t]=0A		printf(\"=
C %d (%s) %d %s %s\\n\", t, name[t], stall_time, time_units, where[t])=0A	}=
=0A=0A	delete stalled[t]=0A	delete name[t]=0A	delete stalled_at[t]=0A	delet=
e where[t]=0A}";=0A	}=0A}=0A=0Aclose($handle);=0A=0A# Contact=0A$stappid =
=3D open(STAP, "stap $stapscript|");=0Aif (!defined($stappid)) {=0A	die("Fa=
iled to execute stap script");=0A}=0A=0A# Collect information until interru=
pted=0Amy %stalled;=0Awhile (1) {=0A	if (eof(STAP)) {=0A		cleanup();=0A		di=
e("Unexpected exit of STAP script");=0A	}=0A=0A	my $input =3D <STAP>;=0A	lo=
g_stap($input);=0A	if ($input !~ /([CS]) ([0-9]*) \((.*)\) ([0-9]*) ms (.*)=
/) {=0A		cleanup();=0A		die("Failed to parse input from stap script\n");=0A=
	}=0A=0A	my $event    =3D $1;=0A	my $pid      =3D $2;=0A	my $name     =3D $=
3;=0A	my $stalled  =3D $4;=0A	my $where    =3D $5;=0A	my $recursed =3D 0;=
=0A	=0A	# Check if we have recursively stalled. This is "impossible" but un=
less=0A	# we are using kretprobes, we cannot reliable catch when stalls com=
plete=0A	if (defined($stalled{$pid}->{NAME}) && $event eq "S") {=0A		$recur=
sed =3D 1;=0A		if ($opt_accurate_stall) {=0A			cleanup();=0A			print("Appar=
ently recursing, missing kretprobes.\n");=0A			print("Process:  $pid ($name=
)\n");=0A			print("Stalled:  " . $stalled{$pid}->{STALLFUNCTION} . "\n");=
=0A			print($stalled{$pid}->{STACKTRACE});=0A			print("Stalling: $where\n")=
;=0A			exit(-1);=0A		}=0A	}=0A=0A	# Record information related to stalls.=
=0A	if ($event eq "C" || $recursed) {=0A		if ($name ne $stalled{$pid}->{NAM=
E}) {=0A			cleanup();=0A			die("Processes are changing their identity.");=
=0A		}=0A		if ($where ne $stalled{$pid}->{STALLFUNCTION}) {=0A			$recursed =
=3D 1;=0A			if ($opt_accurate_stall) {=0A				cleanup();=0A				die("The stal=
ling function teleported.");=0A			}=0A		}=0A=0A		# Do not event pretend the=
 stall time is accurate=0A		if ($recursed) {=0A			$stalled =3D -1;=0A		}=0A=
=0A		$stalled{$pid}->{VMSTAT_AT_COMPLETE} =3D read_vmstat();=0A		$stalled{$=
pid}->{BLOCKSTAT_AT_COMPLETE} =3D read_blockstat("+");=0A		my $delta_writeb=
ack    =3D $stalled{$pid}->{VMSTAT_AT_COMPLETE}[NR_WRITEBACK] - $stalled{$p=
id}->{VMSTAT_AT_STALL}[NR_WRITEBACK];=0A		my $delta_dirty        =3D $stall=
ed{$pid}->{VMSTAT_AT_COMPLETE}[NR_DIRTY]     - $stalled{$pid}->{VMSTAT_AT_S=
TALL}[NR_DIRTY];=0A		my $delta_vmscan_write =3D $stalled{$pid}->{VMSTAT_AT_=
COMPLETE}[VMSCAN_WRITE] - $stalled{$pid}->{VMSTAT_AT_STALL}[VMSCAN_WRITE];=
=0A=0A		# Blind stab in the dark as to what is going on=0A		my $status;=0A	=
	if ($where eq "balance_dirty_pages") {=0A			$status =3D "DirtyThrottled";=
=0A		} else {=0A			$status =3D "IO";=0A		}=0A		if ($delta_writeback < 0) {=
=0A			$status =3D "${status}_WritebackInProgress";=0A		}=0A		if ($delta_wri=
teback > 0) {=0A			$status =3D "${status}_WritebackSlow";=0A		}=0A=0A		log_=
output("time " . time() . ": $pid ($name) Stalled: $stalled ms: $where\n");=
=0A		log_output("Guessing: $status\n");=0A		log_printf("-%-15s %12d\n", "nr=
_dirty",        $stalled{$pid}->{VMSTAT_AT_STALL}[NR_DIRTY]);=0A		log_print=
f("-%-15s %12d\n", "nr_writeback",    $stalled{$pid}->{VMSTAT_AT_STALL}[NR_=
WRITEBACK]);=0A		log_printf("-%-15s %12d\n", "nr_vmscan_write", $stalled{$p=
id}->{VMSTAT_AT_STALL}[VMSCAN_WRITE]);=0A		log_printf("%s", $stalled{$pid}-=
>{BLOCKSTAT_AT_STALL});=0A		log_printf("+%-15s %12d %12d\n", "nr_dirty",=0A=
			$stalled{$pid}->{VMSTAT_AT_COMPLETE}[NR_DIRTY], $delta_dirty);=0A		log_p=
rintf("+%-15s %12d %12d\n", "nr_writeback",=0A			$stalled{$pid}->{VMSTAT_AT=
_COMPLETE}[NR_WRITEBACK], $delta_writeback);=0A		log_printf("+%-15s %12d %1=
2d\n", "nr_vmscan_write",=0A			$stalled{$pid}->{VMSTAT_AT_COMPLETE}[VMSCAN_=
WRITE],=0A			$delta_vmscan_write);=0A		log_printf("%s", $stalled{$pid}->{BL=
OCKSTAT_AT_COMPLETE});=0A		log_output($stalled{$pid}->{STACKTRACE});=0A=0A	=
	delete($stalled{$pid});=0A	}=0A=0A	if ($event eq "S") {=0A		$stalled{$pid}=
->{NAME} =3D $name;=0A		$stalled{$pid}->{STACKTRACE} =3D read_stacktrace($p=
id);=0A		$stalled{$pid}->{VMSTAT_AT_STALL} =3D read_vmstat();=0A		$stalled{=
$pid}->{BLOCKSTAT_AT_STALL} =3D read_blockstat("-");=0A		$stalled{$pid}->{S=
TALLFUNCTION} =3D $where;=0A	}=0A}=0A=0Acleanup();=0Aexit(0);=0A__END__=0Af=
unction time () { return gettimeofday_ms() }=0Aglobal stall_threshold =3D 1=
000=0Aglobal time_units =3D "ms"=0Aglobal name, stalled_at, stalled, where=
=0A=0Aprobe timer.profile {=0A	foreach (tid+ in stalled_at) {=0A		if ([tid]=
 in stalled) continue=0A=0A		stall_time =3D time() - stalled_at[tid]=0A		if=
 (stall_time >=3D stall_threshold) {=0A			printf ("S %d (%s) %d %s %s\n", t=
id, name[tid], stall_time, time_units, where[tid])=0A			stalled[tid] =3D 1 =
# defer further reports to wakeup=0A		}=0A	}=0A}=0A=0A
--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: attachment; filename=stap-dstate-frequency

#!/usr/bin/perl
# This script reads the output from the dstate monitor and reports how
# many unique stack traces there were and what the stall times were.
# The objective is to identify the worst sources of stalls.
#
# Copyright Mel Gorman 2011
use strict;

my $line;
my %unique_event_counts;
my %unique_event_stall;
my %unique_event_stall_details;
my $total_stalled;

my ($process, $stalltime, $function, $event);
my ($stall_details, $trace, $first_trace, $reading_trace, $skip);
while ($line = <>) {
	# Watch for the beginning of a new event
	if ($line =~ /^time ([0-9]*): ([0-9]*) \((.*)\) Stalled: ([-0-9]*) ms: (.*)/) {

		# Skip uninteresting traces
		if (!$skip) {
			# Record the last event
			$unique_event_counts{$trace}++;
			$unique_event_stall_details{$trace} .= $event;
			if ($stalltime >= 0) {
				$unique_event_stall{$trace} += $stalltime;
				$total_stalled += $stalltime;
			}
		}

		# Start the next event
		$event = sprintf "%-20s %-20s %6d ms\n", $3, $5, $4;
		$reading_trace = 0;
		$stalltime = $4;

		if ($stalltime == 0) {
			print "DEBUG $line";
		}

		$first_trace = "";
		$trace = "";
	}

	# If we have reached a trace, blindly read it
	if ($reading_trace) {
		# Ignore traces that look like they are from user space
		if ($line =~ /^\[<0/) {
			$reading_trace = 0;
			next;
		}
		$trace .= $line;
		if ($first_trace eq "") {
			$first_trace = $line;
			$skip = 1;

			# Skip uninteresting traces
			if ($first_trace !~ / do_poll\+/ &&
				$first_trace !~ / kthread\+/ &&
				$first_trace !~ / khugepaged\+/ &&
				$first_trace !~ / sys_epoll_wait\+/ &&
				$first_trace !~ / kswapd\+/) {
				$skip = 0;
			}
		}
		next;
	}

	if ($line =~ /^\[<f/) {
		$reading_trace = 1;
		next;
	}
}

print "Overall stalled time: $total_stalled ms\n\n";
foreach my $trace (sort {$unique_event_stall{$b} <=> $unique_event_stall{$a}} keys %unique_event_stall) {
	#printf "Event $short_event us count %4d\n", $unique_event_counts{$event};
	#print $unique_event_stall_details{$event};
	printf "Time stalled in this event: %8d ms\n", $unique_event_stall{$trace};
	printf "Event count:                %8d\n", $unique_event_counts{$trace};
	print $unique_event_stall_details{$trace};
	print "$trace\n";
}

#print "\nDetails\n=======\n";
#foreach my $event (sort {$unique_event_stall{$b} <=> $unique_event_stall{$a}} keys %unique_event_stall) {
#	print "Event $event us count $unique_event_counts{$event}\n";
#	print "\n";
#}

--45Z9DzgjV8m4Oswq--
