Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab1JASkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 14:40:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56123 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1JASkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 14:40:09 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=eaZrqAE3U5cA:10 a=5SG0PmZfjMsA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=QL4g9HyCIV8P_Ni41qQA:9 a=PUjeQqilurYA:10 a=tkQqPv6h8P8fKz55CacA:9 a=VxQ7KfQ_kS53NgAxKEAA:7 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: w@1wt.eu, greg@kroah.com, linux-kernel@vger.kernel.org
Date: Sat, 01 Oct 2011 14:40:07 -0400
In-Reply-To: <20111001.141343.2293070262147973147.davem@davemloft.net>
References: <20110930235924.GA25176@kroah.com>
	 <20111001073533.GA18690@1wt.eu> <20111001180641.GD6309@home.goodmis.org>
	 <20111001.141343.2293070262147973147.davem@davemloft.net>
Content-Type: multipart/mixed; boundary="=-oucMAtl/7P5izXef/d+k"
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317494408.4588.76.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oucMAtl/7P5izXef/d+k
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

OK, I decided to attach the perl script anyway. It is very crude, and
really needs to be cleaned up for generic use.

I copy this file into /etc/cron.daily/01iptable-update and let the cron
daemon run it. I get nice little reports from cron when something is
added, like:

/etc/cron.daily/01iptables-update:
adding 8.25.218.88 to iptables blocked list
adding 116.125.124.20 to iptables blocked list
adding 38.99.131.171 to iptables blocked list

I officially announce that this file is being released under the GPLv2
license. If you want to fix it up. Feel free, but please send me a
copy ;)

Note, this was written for a Debian system. It reads
the /var/log/auth.log file. Your system may require a different read,
and maybe even different regex parsing.

-- Steve


--=-oucMAtl/7P5izXef/d+k
Content-Type: application/x-perl; name="iptables-examine-logs.pl"
Content-Disposition: attachment; filename="iptables-examine-logs.pl"
Content-Transfer-Encoding: 7bit

#!/usr/bin/perl

use strict;

# after $MAX failures, add to block list
my $MAX = 5;

my $conf_file = "/etc/iptables.conf";

my $ip_match = "\\d+\\.\\d+\\.\\d+\\.\\d+";
my $name_match = "\\S+";

my %blocked_ips;
my @blocked_ips;

my %process_ips;

my %new_blocked_ips;

if (! -f $conf_file) {
	die "$conf_file does not exist";
}

open(IP, $conf_file) || die "can't open $conf_file";
while (<IP>) {
	if (m,-A INPUT -s (.*)/32 -j DROP,) {
		my $ip = $1;
		$blocked_ips[$#blocked_ips+1] = $ip;
		$blocked_ips{$ip} = $#blocked_ips;
	}
}
close IP;


open (IP, "/sbin/iptables -L -n|") || die "can't execute iptables";

my %test_ips = %blocked_ips;

while (<IP>) {
	if (/^DROP\s+all\s+--\s+($ip_match)\s+0\.0\.0\.0\/0\s*$/) {
		my $ip = $1;
		if (!defined($blocked_ips{$ip})) {
			die "$conf_file does not match iptables ($ip not in $conf_file)";
		}
		delete $test_ips{$ip};
	}
}
close IP;

if (keys %test_ips) {
	print STDERR "The following ips are in iptables but not in $conf_file\n";
	foreach my $ip (keys %test_ips) {
		print STDERR "$ip\n";
	}
	exit;
}

sub process_ip {
	my ($ip) = @_;

	if (defined($blocked_ips{$ip}) || defined($new_blocked_ips{$ip})) {
		return;
	}

	if (defined($process_ips{$ip})) {
		if (++$process_ips{$ip} > $MAX) {
			$new_blocked_ips{$ip} = 1;
		}
	} else {
		$process_ips{$ip} = 1;
	}
}	

sub get_ip {
	my ($name) = @_;
	my $start = 0;
	my $ip = "0";

	open (NS, "/usr/bin/nslookup $name|") || die "nslookup";
	while (<NS>) {
		if ($start && /Address: ($ip_match)/) {
			$ip = $1;
			last;
		}
		$start = 1 if (/Name:/);
	}
	close NS;
	return $ip;
}

# add checks here to ignore the IPs
# I should make this read a file instead
sub whitelist_match {
	my ($ip) = @_;

	if ($ip =~ /^192\.168/) {
		return 1;
	}

	return 0;
}

# Reads auth, you may want to have it look elsewhere
open(AUTH, "/var/log/auth.log") || die "can't open auth.log";

while (<AUTH>) {
	if (/sshd\[\d+\]: Invalid user .* from ($ip_match|$name_match)/ ||
	    /sshd\[\d+\]: Failed password for invalid user.* from ($ip_match|$name_match)/) {
		my $ip = $1;
		$ip = get_ip($ip) if ($ip !~ /^[1-9]/);
		process_ip $ip if ($ip =~ /$ip_match/);
	}

	# I've been to hotels where this matches :-(
	if (0 && /sshd\[\d+\]: .*\[($ip_match)].*POSSIBLE BREAK/) {
		my $ip = $1;

		# ignore local network
		if (!whitelist_match($ip)) {
			if (!defined($blocked_ips{$ip}) && !defined($new_blocked_ips{$ip})) {
				$new_blocked_ips{$ip} = 1;
			}
		}
	}
	if (/sshd\[\d+\]: error: .* failure for root from ($ip_match|$name_match)/) {
		my $ip = $1;
		$ip = get_ip($ip) if ($ip !~ /^[1-9]/);
		if (!whitelist_match($ip)) {
			process_ip $ip if ($ip =~ /$ip_match/);
		}
	}
}
close AUTH;

if (! keys %new_blocked_ips) {
	exit;
}

foreach my $ip (keys %new_blocked_ips) {
	print "adding $ip to iptables blocked list\n";
	`/sbin/iptables -A INPUT -s $ip/32 -j DROP`;
	if ($?) {
		die "failed adding $ip to iptables";
	}
}

# make nice new line at the end
print "\n";

`/sbin/iptables-save > $conf_file`;
if ($?) {
	die "failed updating $conf_file"
}


--=-oucMAtl/7P5izXef/d+k--

