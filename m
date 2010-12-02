Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0LBRDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 12:03:45 -0500
Received: from ist.d-labs.de ([213.239.218.44]:58297 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab0LBRDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 12:03:43 -0500
Date: Thu, 2 Dec 2010 18:02:52 +0100
From: Florian Mickler <florian@mickler.org>
To: Tobias Karnat <tobias.karnat@googlemail.com>
Newsgroups: gmane.linux.kernel
Cc: Borislav Petkov <bp@alien8.de>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: edac_core: crashes on shutdown
Message-ID: <20101202180252.05080815@schatten.dmk.lab>
In-Reply-To: <1291306872.3898.7.camel@Tobias-Karnat>
References: <1291201307.3029.21.camel@Tobias-Karnat>
	<20101201123921.GA15530@a1.tnic>
	<1291209888.12511.11.camel@Tobias-Karnat>
	<20101201143329.GB18074@a1.tnic>
	<1291225614.8646.4.camel@Tobias-Karnat>
	<20101201193508.GA4916@liondog.tnic>
	<1291280613.10626.22.camel@Tobias-Karnat>
	<20101202152106.GA29301@a1.tnic>
	<1291306872.3898.7.camel@Tobias-Karnat>
X-Newsreader: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Dec 2010 17:21:12 +0100
Tobias Karnat <tobias.karnat@googlemail.com> wrote:

> Am Donnerstag, den 02.12.2010, 16:21 +0100 schrieb Borislav Petkov:
> > Well, thanks for the photos. I don't have an idea what might cause this
> > workqueue corruption I'm seeing, all reg/unreg paths look ok. The only
> > change that came in between .35 and .36.1 I can think of being relevant
> > is 00740c58541b6087d78418cebca1fcb86dc6077d. You could try backing that
> > one out to see whether it fixes the issue.
> 
> Yes, reverting this fixed the issue!
> 
> But why?
> 
> -Tobias
> 
> 

It doesnt work because op_state is set to OP_OFFLINE in edac_mc_del_mc
before calling edac_mc_workq_teardown. Or am I seeing things?

<snip>
577 struct mem_ctl_info *edac_mc_del_mc(struct device *dev)
578 {
<snip>
592         /* marking MCI offline */
593         mci->op_state = OP_OFFLINE;
594 
595         del_mc_from_global_list(mci);
596         mutex_unlock(&mem_ctls_mutex);
597 
598         /* flush workq processes and remove sysfs */
599         edac_mc_workq_teardown(mci);
<snip>

Probably a better check in _teardown is on a bool that get's set in
edac_mc_workq_setup...?
