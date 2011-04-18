Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab1DRLvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 07:51:51 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:34631 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1DRLvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 07:51:45 -0400
Date: Mon, 18 Apr 2011 13:51:41 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-s390@vger.kernel.org,
        Stephen Powell <zlinuxman@wowway.com>, linux-kernel@vger.kernel.org
Subject: Re: [OOPS s390] Unable to handle kernel pointer dereference at
 virtual kernel address (null)
Message-ID: <20110418115141.GA3157@osiris.boeblingen.de.ibm.com>
References: <2099315211.286690.1302917498637.JavaMail.root@md01.wow.synacor.com>
 <20110416014811.GA6150@elie>
 <20110418084511.GA7786@hal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418084511.GA7786@hal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:45:11AM +0200, Jan Glauber wrote:
> On Fri, Apr 15, 2011 at 08:48:40PM -0500, Jonathan Nieder wrote:
> > Hi,
> > 
> > Here's an oops that was reported to Debian[1].  It cannot be
> > reproduced on demand but it is reproducible with enough time.  It did
> > not appear on v2.6.32; it does appear on Debian 2.6.38-3 (which is
> > based on gregkh's v2.6.38.2) and pristine v2.6.39-rc3, so looks like
> > a regression.

It's probably easily reproducible if you put enough memory pressure on
the whole vm system, since this triggers a bug a in the pfault code.

> > > [ 2698.053263] Kernel panic - not syncing: Fatal exception in interrupt
> > > [ 2698.053316] CPU: 0 Tainted: G      D      2.6.38-2-s390x #1
> > > [ 2698.053502] Process cron (pid: 1106, task: 000000001f962f78, ksp: 000000001fa0f9d0)
> > > [ 2698.053516]        0000000000000000 000000001ff7fa70 0000000000000002 0000000000000000
> > > [ 2698.053539]        000000001ff7fb10 000000001ff7fa88 000000001ff7fa88 0000000000397b9e
> > > [ 2698.053576]        0000000000000001 0000000000000000 000000001ff03280 0000000000000000
> > > [ 2698.053623]        0000000000000008 0000000000000000 000000000000000e 0000000000000078
> > > [ 2698.053674]        000000001ff7faf0 0000000000011b36 000000001ff7fa70 000000001ff7fab8
> > > [ 2698.053740] Call Trace:
> > > [ 2698.053762] ([<0000000000011a60>] show_trace+0x5c/0xa4)
> > > [ 2698.053801]  [<00000000003979de>] panic+0x9e/0x214
> > > [ 2698.054443]  [<0000000000012046>] die+0x15e/0x170
> > > [ 2698.054485]  [<000000000002c5d6>] do_no_context+0xd6/0xe0
> > > [ 2698.054529]  [<000000000002cd52>] do_protection_exception+0x46/0x2a0
> > > [ 2698.054577]  [<000000000039b208>] pgm_exit+0x0/0x4
> > > [ 2698.054627]  [<000000000002c03e>] pfault_interrupt+0xa2/0x138
> > > [ 2698.054679] ([<000000001f962f78>] 0x1f962f78)
> > > [ 2698.056408]  [<000000000001acda>] do_extint+0xf6/0x138
> > > [ 2698.056424]  [<000000000039b6ca>] ext_no_vtime+0x30/0x34
> > > [ 2698.056439]  [<000000007d706e04>] 0x7d706e04
> > > HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 0001DE26
> > [...]
> > 
> > > On Thu, 14 Apr 2011 21:48:56 -0400 (EDT), Stephen Powell wrote:
> > 
> > >> The problem appears to be fixed in the latest vanilla upstream kernel
> > >> source, which at the time of this writing is 2.6.39-rc3.
> > >> ...
> > >
> > > Oops!  I spoke too soon.  I checked the server before I went to bed
> > > last night, and it was still up at that time; but when I got up this
> > > morning I checked it again, and it had crashed during the night with
> > > the same protection exception at the same offset in the same function.
> > > That's the trouble with these kind of bugs.
> > 
> > Ideas?

That's a bug in the pfault interrupt code. After a cleanup patch which
simplified lowcore accesses we are left with a dereference which shouldn't
be there.
The patch below should fix it. The bug was introduced with 2.6.37-rc1.

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 9217e33..4cf85fe 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -558,9 +558,9 @@ static void pfault_interrupt(unsigned int ext_int_code,
 	 * Get the token (= address of the task structure of the affected task).
 	 */
 #ifdef CONFIG_64BIT
-	tsk = *(struct task_struct **) param64;
+	tsk = (struct task_struct *) param64;
 #else
-	tsk = *(struct task_struct **) param32;
+	tsk = (struct task_struct *) param32;
 #endif
 
 	if (subcode & 0x0080) {
