Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab1IHJJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 05:09:35 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:56372 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab1IHJJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 05:09:33 -0400
Date: Thu, 8 Sep 2011 18:13:53 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, axboe@kernel.dk,
        vgoyal@redhat.com, takuya.yoshikawa@gmail.com
Subject: CFQ I/O starvation problem triggered by RHEL6.0 KVM guests
Message-Id: <20110908181353.8b3eb66d.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a report of strange cfq behaviour which seems to be triggered by
QEMU posix aio threads.

Host environment:
  OS: RHEL6.0 KVM/qemu-kvm (with no patch applied)
  IO scheduler: cfq (with the default parameters)

On the host, we were running 3 linux guests to see if I/O from these guests
would be handled fairly by host; each guest did dd write with oflag=direct.

Guest virtual disk:
  We used a host local disk which had 3 partitions, and each guest was
  allocated one of these as dd write target.

So our test was for checking if cfq could keep fairness for the 3 guests
who shared the same disk.

The result (strage starvation):
  Sometimes, one guest dominated cfq for more than 10sec and requests from
  other guests were not handled at all during that time.

Below is the blktrace log which shows that a request to (8,27) in cfq2068S (*1)
is not handled at all during cfq2095S and cfq2067S which hold requests to
(8,26) are being handled alternately.

*1) WS 104920578 + 64

Question:
  I guess that cfq_close_cooperator() was being called in an unusual manner.
  If so, do you think that cfq is responsible for keeping fairness for this
  kind of unusual write requests?

Note:
  With RHEL6.1, this problem could not triggered. But I guess that was due to
  QEMU's block layer updates.

Thanks,
	Takuya

--- blktrace log ---
  8,16   0     2010     0.275081840  2068  A  WS 104920578 + 64 <- (8,27) 0
  8,16   0     2011     0.275082180  2068  Q  WS 104920578 + 64 [qemu-kvm]
  8,16   0        0     0.275091369     0  m   N cfq2068S / alloced
  8,16   0     2012     0.275091909  2068  G  WS 104920578 + 64 [qemu-kvm]
  8,16   0     2013     0.275093352  2068  P   N [qemu-kvm]
  8,16   0     2014     0.275094059  2068  I   W 104920578 + 64 [qemu-kvm]
  8,16   0        0     0.275094887     0  m   N cfq2068S / insert_request
  8,16   0        0     0.275095742     0  m   N cfq2068S / add_to_rr
  8,16   0     2015     0.275097194  2068  U   N [qemu-kvm] 1
  8,16   2     2073     0.275189462  2095  A  WS 83979688 + 64 <- (8,26) 40000
  8,16   2     2074     0.275189989  2095  Q  WS 83979688 + 64 [qemu-kvm]
  8,16   2     2075     0.275192534  2095  G  WS 83979688 + 64 [qemu-kvm]
  8,16   2     2076     0.275193909  2095  I   W 83979688 + 64 [qemu-kvm]
  8,16   2        0     0.275195609     0  m   N cfq2095S / insert_request
  8,16   2        0     0.275196404     0  m   N cfq2095S / add_to_rr
  8,16   2        0     0.275198004     0  m   N cfq2095S / preempt
  8,16   2        0     0.275198688     0  m   N cfq2067S / slice expired t=1
  8,16   2        0     0.275199631     0  m   N cfq2067S / resid=100
  8,16   2        0     0.275200413     0  m   N cfq2067S / sl_used=1
  8,16   2        0     0.275201521     0  m   N / served: vt=1671968768 min_vt=1671966720
  8,16   2        0     0.275202323     0  m   N cfq2067S / del_from_rr
  8,16   2        0     0.275204263     0  m   N cfq2095S / set_active wl_prio:0 wl_type:2
  8,16   2        0     0.275205131     0  m   N cfq2095S / fifo=(null)
  8,16   2        0     0.275205851     0  m   N cfq2095S / dispatch_insert
  8,16   2        0     0.275207121     0  m   N cfq2095S / dispatched a request
  8,16   2        0     0.275207873     0  m   N cfq2095S / activate rq, drv=1
  8,16   2     2077     0.275208198  2095  D   W 83979688 + 64 [qemu-kvm]
  8,16   2     2078     0.275269567  2095  U   N [qemu-kvm] 2
  8,16   4      836     0.275483550     0  C   W 83979688 + 64 [0]
  8,16   4        0     0.275496745     0  m   N cfq2095S / complete rqnoidle 0
  8,16   4        0     0.275497825     0  m   N cfq2095S / set_slice=100
  8,16   4        0     0.275499512     0  m   N cfq2095S / arm_idle: 8
  8,16   4        0     0.275499862     0  m   N cfq schedule dispatch
  8,16   6       85     0.275626195  2067  A  WS 83979752 + 64 <- (8,26) 40064
  8,16   6       86     0.275626598  2067  Q  WS 83979752 + 64 [qemu-kvm]
  8,16   6       87     0.275628580  2067  G  WS 83979752 + 64 [qemu-kvm]
  8,16   6       88     0.275629630  2067  I   W 83979752 + 64 [qemu-kvm]
  8,16   6        0     0.275631047     0  m   N cfq2067S / insert_request
  8,16   6        0     0.275631730     0  m   N cfq2067S / add_to_rr
  8,16   6        0     0.275633567     0  m   N cfq2067S / preempt
  8,16   6        0     0.275634275     0  m   N cfq2095S / slice expired t=1
  8,16   6        0     0.275635285     0  m   N cfq2095S / resid=100
  8,16   6        0     0.275635985     0  m   N cfq2095S / sl_used=1
  8,16   6        0     0.275636882     0  m   N / served: vt=1671970816 min_vt=1671968768
  8,16   6        0     0.275637585     0  m   N cfq2095S / del_from_rr
  8,16   6        0     0.275639382     0  m   N cfq2067S / set_active wl_prio:0 wl_type:2
  8,16   6        0     0.275640222     0  m   N cfq2067S / fifo=(null)
  8,16   6        0     0.275640809     0  m   N cfq2067S / dispatch_insert
  8,16   6        0     0.275641929     0  m   N cfq2067S / dispatched a request
  8,16   6        0     0.275642699     0  m   N cfq2067S / activate rq, drv=1
  8,16   6       89     0.275643047  2067  D   W 83979752 + 64 [qemu-kvm]
  8,16   6       90     0.275702446  2067  U   N [qemu-kvm] 2
  8,16   4      837     0.275864044     0  C   W 83979752 + 64 [0]
  8,16   4        0     0.275869194     0  m   N cfq2067S / complete rqnoidle 0
  8,16   4        0     0.275870399     0  m   N cfq2067S / set_slice=100
  8,16   4        0     0.275872046     0  m   N cfq2067S / arm_idle: 8
  8,16   4        0     0.275872442     0  m   N cfq schedule dispatch
....
... more than 10sec ...
....
  8,16   4        0    13.854114096     0  m   N cfq schedule dispatch
  8,16   4        0    13.854123729     0  m   N cfq2068S / set_active wl_prio:0 wl_type:2
  8,16   4        0    13.854125678     0  m   N cfq2068S / fifo=ffff880bddcec780
  8,16   4        0    13.854126416     0  m   N cfq2068S / dispatch_insert
  8,16   4        0    13.854128441     0  m   N cfq2068S / dispatched a request
  8,16   4        0    13.854129303     0  m   N cfq2068S / activate rq, drv=1
  8,16   4    23836    13.854130246    54  D   W 104920578 + 64 [kblockd/4]
  8,16   4    23837    13.855439985     0  C   W 104920578 + 64 [0]
  8,16   4        0    13.855450434     0  m   N cfq2068S / complete rqnoidle 0
  8,16   4        0    13.855451909     0  m   N cfq2068S / set_slice=100
  8,16   4        0    13.855453604     0  m   N cfq2068S / arm_idle: 8
  8,16   4        0    13.855454099     0  m   N cfq schedule dispatch
  8,16   0    48186    13.855686027  2102  A  WS 104920642 + 64 <- (8,27) 64
  8,16   0    48187    13.855686537  2102  Q  WS 104920642 + 64 [qemu-kvm]
  8,16   0        0    13.855698094     0  m   N cfq2102S / alloced
  8,16   0    48188    13.855698528  2102  G  WS 104920642 + 64 [qemu-kvm]
  8,16   0    48189    13.855700281  2102  I   W 104920642 + 64 [qemu-kvm]
  8,16   0        0    13.855701243     0  m   N cfq2102S / insert_request
  8,16   0        0    13.855701974     0  m   N cfq2102S / add_to_rr
  8,16   0        0    13.855704313     0  m   N cfq2102S / preempt
  8,16   0        0    13.855705068     0  m   N cfq2068S / slice expired t=1
  8,16   0        0    13.855706191     0  m   N cfq2068S / resid=100
  8,16   0        0    13.855706993     0  m   N cfq2068S / sl_used=1
  8,16   0        0    13.855708228     0  m   N / served: vt=1736314880 min_vt=1736312832
  8,16   0        0    13.855709046     0  m   N cfq2068S / del_from_rr


-- 
Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
