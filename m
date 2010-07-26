Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0GZVWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 17:22:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab0GZVWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 17:22:16 -0400
Date: Mon, 26 Jul 2010 17:21:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, nauman@google.com, dpshah@google.com,
        guijianfeng@cn.fujitsu.com, jmoyer@redhat.com
Subject: Tuning IO scheduler (Was: Re: [RFC PATCH] cfq-iosced: Implement IOPS
 mode and group_idle tunable V3)
Message-ID: <20100726212158.GQ12449@redhat.com>
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
 <20100722055602.GA18566@infradead.org>
 <20100722140044.GA28684@redhat.com>
 <20100724085135.GB32006@infradead.org>
 <AANLkTi=d-2-1R_Bpk_1J7AXhTc2Kv3p8S7tE0ZsFKFDe@mail.gmail.com>
 <20100726143023.GF12449@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <20100726143023.GF12449@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 26, 2010 at 10:30:23AM -0400, Vivek Goyal wrote:
> On Sat, Jul 24, 2010 at 11:07:07AM +0200, Corrado Zoccolo wrote:
> > On Sat, Jul 24, 2010 at 10:51 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > > To me this sounds like slice_idle=0 is the right default then, as it
> > > gives useful behaviour for all systems linux runs on.
> > No, it will give bad performance on single disks, possibly worse than
> > deadline (deadline at least sorts the requests between different
> > queues, while CFQ with slice_idle=0 doesn't even do this for readers).
> 
> > Setting slice_idle to 0 should be considered only when a single
> > sequential reader cannot saturate the disk bandwidth, and this happens
> > only on smart enough hardware with large number of spindles.
> 
> I was thinking of writting a user space utility which can launch
> increasing number of parallel direct/buffered reads from device and if
> device can sustain more than 1 parallel reads with increasing throughput,
> then it probably is good indicator that one might be better off with
> slice_idle=0.
> 
> Will try that today...

Ok, here is a small hackish bash script which takes a block device as
input. It runs multiple parallel sequential readers in raw mode (dd on
block device) and measures the total throughput. I run readers on 
different areas of disks so that readers don't overlap and don't end up
reading same block.

The idea is to write a simple script which can run bunch of tests and
suggest to user what IO scheduler to run or what IO scheduler tunable to
use. At this point of time I am only looking to identify if we should
use slice_idle or not in CFQ on a given block device.

Here are some results of various runs. First column reporesents number of
processes run in paralle, second column is total BW and third column is
bandwidth of individual dd processes. Throughputs are in MB/s.

SATA disk
=========
Noop
----
1       63.3      63.3
2       18.7      9.4 9.3
4       21.6      5.5 5.4 5.4 5.3
8       29.6      5.9 4.5 3.6 3.5 3.3 3.0 3.0 2.8

CFQ
---
1       63.2      63.2
2       54.8      29.2 25.6
4       50.3      13.9 12.8 12.1 11.5
8       42.9      6.0 5.8 5.5 5.4 5.2 5.1 5.0 4.9

Storage Array (12 disks in RAID 5 configuration)
================================================
Noop
----
1       62.5      62.5
2       86.5      46.1 40.4
4       98.7      32.4 24.3 21.9 20.1
8       112.5     15.8 15.5 15.3 13.6 13.6 13.3 13.2 12.2

CFQ
---
1       56.9      56.9
2       34.8      18.0 16.8
4       38.8      10.4 10.3 9.4 8.7
8       44.4      6.1 6.1 5.9 5.9 5.7 5.0 4.9 4.8

SSD
===
Noop
----
1       243       243
2       231       122 109
4       270.6     73.8 73.5 65.1 58.2
8       262.9     33.3 33.2 33.2 33.2 33.2 33.2 33.2 30.4

CFQ
---
1       244       244
2       228       120 108
4       260.6     67.1 67.0 67.0 59.5
8       266.0     35.0 33.4 33.4 33.4 33.4 33.4 33.4 30.6

Summary:

- On SATA disk with single spindle as number of processes increase (2),
  disk starts experiencing seeks and throughput drops dramatically. Here
  CFQ idling helps.

- On storage array, with noop, total throughput increases as number of
  dd processes increase. That means underlying storage can support
  multiple parallel readers without getting seek bound. In this probably
  one should set slice_idle=0

- With SSD throughput does not deteriorate as number of readers are
  incrased. CFQ also performs well because internally idling is disabled
  as SSD is marked as non-rotational device.

So bottom line, if device can support multiple parallel read stream
without significant drop in throughput, one can set slice_idle=0 in CFQ
to achieve better overall throughput.

This will primarily be true for data disks and not root disk as it does not
gurantee better latencies in presence of buffered WRITES.

Thanks
Vivek


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=iostune

#!/bin/bash
#
# A script intended to provide help with characterizing a block device and
# provide help with setting IO scheduler tunbales accordingly.
#
# Author: Vivek Goyal <vgoyal@redhat.com>


generate_report_nr_procs () {
	local nr_procs=$1
	local individual_bw
	local individual_bw_copy
	local bw
	local total_bw=0

	individual_bw=`cat $TEMPFILE | sed -n "/BEGIN NR_PROCESSES=$nr_procs/,/END NR_PROCESSES=$nr_procs/p" | grep "bytes.*copied" | awk -F ',' '{print $3}' | awk '{print $1}' | sed -e :a -e '$!N;s/\n/ /;ta'`

#	echo "individual bw is $individual_bw"

	for bw in $individual_bw;do
		total_bw=`echo "$total_bw + $bw" | bc`
	done

	printf "%-8s%-10s%-60s\n" $nr_procs $total_bw "$individual_bw"
}

generate_report () {
	local i

	for ((i=1; i<=$MAX_NR_PROCESSES; i=$i*2)) {
		generate_report_nr_procs $i
	}
}

# Run the test for nr processes
run_test_nr_processes () {
	local nr_processes=$1
	local bdev_size_bytes=`blockdev --getsize64 $BLOCKDEV`
	local bdev_nr_ibs=$(($bdev_size_bytes/$BS))
	local nr_ibs_per_process=$(($bdev_nr_ibs/$nr_processes))
	local j

	# disk might be big. By default read 512MB of data per process
	local nr_blocks_to_read=$(((512*1024*1024)/$BS))

	# Run processes
	for((j=1; j<=$nr_processes; j++)) {
		local skip_mult=$(($j-1))
		local skip_blocks=$(($nr_ibs_per_process*$skip_mult))

		dd if=$BLOCKDEV of=/dev/null ibs=$BS count=$nr_blocks_to_read skip=$skip_blocks >> $TEMPFILE 2>&1 &
	}

}

start_test () {
	local i

	# Launch increasing number of dd threads. Determine device capacity
	# divide the total capacity by number of threads and let different
	# threads work on different area of block device.

	echo "Will Run up to $MAX_NR_PROCESSES readers"

	for((i=1; i<=$MAX_NR_PROCESSES; i=$i*2)) {
		echo "Running test with $i readers"
		echo "BEGIN NR_PROCESSES=$i" >> $TEMPFILE
		run_test_nr_processes $i
		wait
		echo "END NR_PROCESSES=$i" >> $TEMPFILE
	}
}

Usage () {
	echo "Usage: $0 DEVICE"
}

# Main script
if [ $# -lt 1 ];then
	Usage
	exit 1
fi

BLOCKDEV=$1
# default block size
BS=4096
TEMPFILE=`mktemp /tmp/iostune.XXXXX`
MAX_NR_PROCESSES=8

if [ ! -b "$BLOCKDEV" ];then
	echo "Error: $BLOCKDEV is not a block device."
	exit 1
fi

start_test
wait
generate_report

--82I3+IH0IqGh5yIs--
