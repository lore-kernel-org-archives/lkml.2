Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935203Ab1JERVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:21:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935027Ab1JERU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:20:59 -0400
Date: Wed, 5 Oct 2011 13:20:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Valdis.Kletnieks@vt.edu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111005172035.GH30146@redhat.com>
References: <20111003073203.GA22694@in.ibm.com>
 <m162k64c7w.fsf@fess.ebiederm.org>
 <20111003120336.GK2223@in.ibm.com>
 <20111004063440.GB5723@liondog.tnic>
 <20111005070728.GA2235@in.ibm.com>
 <20111005073111.GA13478@liondog.tnic>
 <20111005094727.GB7485@in.ibm.com>
 <20111005155217.GE30146@redhat.com>
 <10327.1317830438@turing-police.cc.vt.edu>
 <20111005161626.GB18592@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005161626.GB18592@gere.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 06:16:26PM +0200, Borislav Petkov wrote:
> On Wed, Oct 05, 2011 at 12:00:38PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 05 Oct 2011 11:52:17 EDT, Vivek Goyal said:
> > 
> > > I am assuming that basic MCE error messages are available in kernel log. 
> > 
> > They're not in the kernel log if it's an MCE that causes the kernel to declare
> > a panic. There's some MCE's that you can retry the operation and continue, and
> > some that you can get away with poisoning a page, killing the process, and rest
> > of the system is OK.  But some you really need to roll over and die because you
> > can't guarantee kernel integrity anymore.
> > 
> > And at that point, those messages are never gonna make it to syslogd and onto
> > disk.
> 
> AFAICT, and for the sake of getting the MCE info, arguably one could
> look for log_buf in the vmcore of the old kernel and try to find the
> last lines in the kernel log ringbuffer. They should be the MCE error
> information from the do_machine_check MCE handler.
> 
> This all assuming of course we've managed to dump vmcore successfully by
> sidestepping the landmines :-).

We don't have to dump the whole vmcore. "makedumpfile" can extract just
the kernel log buffer. Following is a excerpt from makedumpfile man page.

***************************************************************************
       --dump-dmesg
              This option  overrides  the  normal  behavior  of makedumpfile.
              Instead  of  compressing  and  filtering  a  VMCORE  to make it
              smaller, it simply extracts the dmesg  log  from  a  VMCORE and
              writes it to the specified LOGFILE.

*****************************************************************************

So we can automate the whole thing by first extracting dmesg only, looking
for MCE messages and if there is none in last few lines, then save the
whole vmcore otherwise just save dmesg.

Or break down the dump saving process in two parts. First we just extract
and save the dmesg in a file and then try to save vmcore and in the
process if MCE happens, anyway we will reboot.

Exporting an ELF note just makes MCE information more structured instead
of scanning through dmesg.

Thanks
Vivek
