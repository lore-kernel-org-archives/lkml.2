Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab2KNBk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:40:28 -0500
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:53278 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab2KNBk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:40:26 -0500
X-AuditID: b753bd60-94fe2ba000004744-48-50a2f60546b9
X-AuditID: b753bd60-94fe2ba000004744-48-50a2f60546b9
Subject: [RFC PATCH 2/2] tools: Add a tool for merging trace data of a guest
 and a host
To: linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>, David Sharp <dhsharp@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 14 Nov 2012 10:37:26 +0900
Message-ID: <20121114013716.5338.37763.stgit@yunodevel>
In-Reply-To: <20121114013611.5338.15086.stgit@yunodevel>
References: <20121114013611.5338.15086.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tool merges trace data of a guest and a host in chronological order.
Note that this tool is used only for a guest and a host. (not for multiple
guests)

- How to use
1. Get trace data of the host and guest via ssh, virtio-serial, or virtio-trace

2. Get TSC offset after applied patch "kvm/vmx: Print TSC_OFFSET information
   when TSC offset value is written to VMCS"
$ dmesg | grep kvm
[   57.717180] kvm: ([PID]) write TSC offset [TSC offset], now clock [HOST TSC]

3. Use this tool
$ ./trace-merge.pl <TSC offset> <host data> <guest data>

h        qemu-kvm-2687  [003] d...50550079203669: kvm_exit: [detail]
h        qemu-kvm-2687  [003] d...50550079206816: kvm_entry: [detail]
g            comm-3826  [000] d.h.50550079226331: sched_wakeup: [detail]
h        qemu-kvm-2687  [003] d...50550079240656: kvm_exit: [detail]
h        qemu-kvm-2687  [003] d...50550079243467: kvm_entry: [detail]
h        qemu-kvm-2687  [003] d...50550079256103: kvm_exit: [detail]
h        qemu-kvm-2687  [003] d...50550079268391: kvm_entry: [detail]
g            comm-3826  [000] d...50550079279266: sched_switch: [detail]
h        qemu-kvm-2687  [003] d...50550079280829: kvm_exit: [detail]
h        qemu-kvm-2687  [003] d...50550079286028: kvm_entry: [detail]
|
\----guest/host

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 tools/scripts/trace-merge/trace-merge.pl |  109 ++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)
 create mode 100755 tools/scripts/trace-merge/trace-merge.pl

diff --git a/tools/scripts/trace-merge/trace-merge.pl b/tools/scripts/trace-merge/trace-merge.pl
new file mode 100755
index 0000000..e0b080c
--- /dev/null
+++ b/tools/scripts/trace-merge/trace-merge.pl
@@ -0,0 +1,109 @@
+#!/usr/bin/perl
+#
+# Tool for merging and sorting trace data of a guest and host
+#
+# Created by Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
+#
+# - How to use
+#   ./trace-merge.pl <TSC offset> <host data> <guest data>
+#
+use strict;
+use bigint;
+
+my %all_data_info = ();
+my @merged_data = ();
+my @sorted_data = ();
+
+&read_all_data();
+&merge_guest_host_data();
+&sort_data_by_tsc();
+&output_data();
+
+sub read_all_data {
+	# TSC offset value is very big ull value.
+	# This value is actually negative, so we calculate the value here.
+	$all_data_info{"tsc_offset"} = &convert_tscoffset($ARGV[0]);
+	if ($all_data_info{"tsc_offset"} == 0) {
+		die "TSC should not be 0";
+	}
+
+	if (!open(HOST_DATA, $ARGV[1])) {
+		die "Cannot open host file: $!"
+	}
+	my @host_data = <HOST_DATA>;
+	close(HOST_DATA);
+
+	if (!open(GUEST_DATA, $ARGV[2])) {
+		die "Cannot open guest file: $!"
+	}
+	my @guest_data = <GUEST_DATA>;
+	close(GUEST_DATA);
+
+	$all_data_info{"host_data"} = \@host_data;
+	$all_data_info{"guest_data"} = \@guest_data;
+}
+
+sub merge_guest_host_data {
+	&guest_push_data();
+	&host_push_data();
+}
+
+sub sort_data_by_tsc {
+	no strict 'refs';
+	@sorted_data = sort {$a->{tsc} <=> $b->{tsc}} @merged_data;
+}
+
+sub output_data {
+	foreach my $line (@sorted_data) {
+		print "$line->{name}$line->{comm}$line->{tsc}$line->{event}\n";
+	}
+}
+
+sub guest_push_data {
+	&make_data_list(1);
+}
+
+sub host_push_data {
+	&make_data_list(0);
+}
+
+#
+# If this function is used for guest's data,
+# subtract TSC offset from guest's TSC value.
+#
+# NOTE: guest's TSC is added TSC offset to actual TSC when the guest boots.
+#
+sub make_data_list {
+	my $is_guest = $_[0];
+	my @data = ();
+	my $name = "";
+	my $list = "";
+	my $tsc_offset = 0;
+
+	if ($is_guest eq 1) {
+		$name = "g";
+		@data = @{$all_data_info{"guest_data"}};
+		$tsc_offset = $all_data_info{"tsc_offset"};
+	} else {
+		$name = "h";
+		@data = @{$all_data_info{"host_data"}};
+	}
+
+	foreach my $line (@data) {
+		chomp($line);
+
+		if ($line =~ /^(.+\[[0-9]+\].{5})([0-9]+)(:.+)/) {
+			$list = {
+				name	=> $name,
+				comm	=> $1,
+				tsc	=> $2 - $tsc_offset,
+				event	=> $3
+			};
+			push(@merged_data, $list);
+		}
+	}
+}
+
+sub convert_tscoffset {
+	return $_[0] - (1 << 64);
+}


