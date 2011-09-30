Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab1I3JFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:05:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:48937 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964Ab1I3JFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:05:12 -0400
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tejun Heo <htejun@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 30 Sep 2011 11:04:33 +0200
In-Reply-To: <20110930085510.GA23868@mtj.dyndns.org>
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
	 <20110930034815.GF10425@mtj.dyndns.org>
	 <1317355529.4588.45.camel@gandalf.stny.rr.com>
	 <20110930041424.GH10425@mtj.dyndns.org> <1317371699.19415.6.camel@twins>
	 <20110930085510.GA23868@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317373473.19415.10.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 01:55 -0700, Tejun Heo wrote:
> Hello, Peter.
> 
> On Fri, Sep 30, 2011 at 10:34:59AM +0200, Peter Zijlstra wrote:
> > On Thu, 2011-09-29 at 21:14 -0700, Tejun Heo wrote:
> > > It's rather complicated due to the way workqueues have been used.  You
> > > can't tell whether a work really needs to be pinned to one cpu for
> > > correctness until actual cpu hotplug time as wq users are expected to
> > > flush such work items from hotplug notifiers, so wq workers should be
> > > pinned on the respective cpus while the cpus are up but also need to
> > > step aside once unplug notifiers are finished. 
> > 
> > That really is crack, and I've always said so.
> > 
> > How about we fix that utter workqueue unplug nightmare..
> 
> The patch is corrupt (=20/=3D's).  Can you please re-send?

Fucking mailer insists on quoted-printable for plain text :/

I've got something like the below awk in my mail->patch pipe:

/Content-Transfer-Encoding:.*quoted-printable.*/ {
        decode = 1;
}
// {
	tmp = $0
	if (!decode) {
		print tmp
		next
	}
	if (concat) {
                tmp = last tmp
                concat = 0;
        }
        if (tmp ~ /=$/) {
                concat = 1;
                gsub("=$", "", tmp);
        }
        offset = 0;
        while (match(tmp, /=[[:xdigit:]][[:xdigit:]]/, a)) {
                if (a[0] < offset)
                        break;
                hex = substr(a[0], 2)
                char = sprintf("%c", strtonum("0x"hex))
                gsub(a[0], char, tmp)
                offset = a[0];
        }
        if (concat) {
                last = tmp
                next
        }
        print tmp
}
