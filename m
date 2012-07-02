Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab2GBL6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:58:25 -0400
Received: from trent.utfs.org ([94.185.90.103]:36978 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab2GBL6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:58:23 -0400
Date: Mon, 2 Jul 2012 04:58:08 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        dan.j.williams@intel.com, JBottomley@Parallels.com,
        stern@rowland.harvard.edu
Subject: Re: 3.5.0-rc5: BUG: soft lockup - CPU#0 stuck for 22s
In-Reply-To: <1341204649.2588.29.camel@pasglop>
Message-ID: <alpine.DEB.2.01.1207020442060.5568@trent.utfs.org>
References: <alpine.DEB.2.01.1207010009270.5568@trent.utfs.org> <1341204649.2588.29.camel@pasglop>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012 at 14:50, Benjamin Herrenschmidt wrote:
> > while trying to upgrade from 3.4.0 to 3.5.0-rc5 on this Powerbook G4 
> > (powerpc 32 bit), this happens during booting:
> > 
> > --------------
> > usb 2-1: new full-speed USB device number 4 using ohci_hcd
> > SCSI subsystem initialized
> > scsi0 : SBP-2 IEEE-1394
> > scsi1 : SBP-2 IEEE-1394
> > firewire_sbp2 fw1.0: logged in to LUN 0000 (0 retries)
> > scsi 0:0:0:0: Direct-Access     Ext Hard  Disk            PQ: 0 ANSI: 4
> 
> Interesting... I observed something roughly similar on a dual G4
> the other day associated with a 30s to 1mn pause during boot. RCU
> was complaining loudly.
> 
> In my case, it did continue booting normally, is that the case for you ?
> 
> Also if I compile the kernel without CONFIG_SMP, it did go away as well,
> do you observe that too ?
> 
> I don't have a spare cycle to investigate this problem this week I'm
> afraid, it might help if you could try a bisection though.

OK, after a git-bisect, the following commit has been identified as bad:

---------------------------
a7a20d103994fd760766e6c9d494daa569cbfe06 is the first bad commit
commit a7a20d103994fd760766e6c9d494daa569cbfe06
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Mar 22 17:05:11 2012 -0700

    [SCSI] sd: limit the scope of the async probe domain
---------------------------

Unfortunately it's not possible to "git revert" just this single commit:

------------
$ git revert a7a20d103994fd760766e6c9d494daa569cbfe06
error: could not revert a7a20d1... [SCSI] sd: limit the scope of the async probe domain
hint: after resolving the conflicts, mark the corrected paths  
hint: with 'git add <paths>' or 'git rm <paths>'
hint: and commit the result with 'git commit'
------------

I _guess_ this is probably due to:

------------
commit ea80dadec7a06889562b478cf0b87afbe62b7ac8
Author: James Bottomley <JBottomley@Parallels.com>
Date:   Wed Jun 6 14:54:13 2012 +0900

    [SCSI] Fix sd_probe_domain config problem
------------

The whole git-bisect log, dmesg, .config and so on is here:

  http://nerdbynature.de/bits/3.5.0-rc5/soft_lockup/

Anyone got an idea how to go from here?

Thanks,
Christian.
-- 
BOFH excuse #380:

Operators killed when huge stack of backup tapes fell over.
