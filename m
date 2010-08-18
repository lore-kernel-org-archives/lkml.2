Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab0HRGTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 02:19:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:5052 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab0HRGTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 02:19:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,226,1280732400"; 
   d="scan'208";a="313834202"
Subject: hackbench regression with 2.6.36-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LKML <linux-kernel@vger.kernel.org>, alex.shi@intel.com,
        Pavel Emelyanov <xemul@openvz.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 18 Aug 2010 14:18:37 +0800
Message-Id: <1282112318.21202.8.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.35's result, hackbench (thread mode) has about
80% regression on dual-socket Nehalem machine and about 90% regression
on 4-socket Tigerton machines.

Command to start hackbench:
#./hackbench 100 thread 2000

process mode has no such regression.

Profiling shows:
#perf top
             samples  pcnt function                 DSO
             _______ _____ ________________________ ________________________

            74415.00 29.9% put_pid                  [kernel.kallsyms]       
            38395.00 15.4% unix_stream_recvmsg      [kernel.kallsyms]       
            34877.00 14.0% unix_stream_sendmsg      [kernel.kallsyms]       
            25204.00 10.1% pid_vnr                  [kernel.kallsyms]       
            21864.00  8.8% unix_scm_to_skb          [kernel.kallsyms]       
            13637.00  5.5% cred_to_ucred            [kernel.kallsyms]       
             6520.00  2.6% unix_destruct_scm        [kernel.kallsyms]       
             4731.00  1.9% sock_alloc_send_pskb     [kernel.kallsyms]       


With 2.6.35, perf doesn't show put_pid/pid_vnr.

Alex Shi and I did a quick bisect and located below 2 patches.
1) commit 7361c36c5224519b258219fe3d0e8abc865d8134
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Sun Jun 13 03:34:33 2010 +0000

    af_unix: Allow credentials to work across user and pid namespaces.

    In unix_skb_parms store pointers to struct pid and struct cred instead
    of raw uid, gid, and pid values, then translate the credentials on
    reception into values that are meaningful in the receiving processes
    namespaces.


2) commit 257b5358b32f17e0603b6ff57b13610b0e02348f
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Sun Jun 13 03:32:34 2010 +0000

    scm: Capture the full credentials of the scm sender.

    Start capturing not only the userspace pid, uid and gid values of the
    sending process but also the struct pid and struct cred of the sending
    process as well.




