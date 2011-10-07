Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab1JGWA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 18:00:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35082 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1JGWAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 18:00:55 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=gxfjmhR6zbwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=cahJxx6UZF3xCAIBq47FAQ==:17 a=zBK5yZjOAAAA:8 a=mWILyxohiJLPY4WqqIoA:9 a=wWYzvfqj6_-I5wr8oGgA:7 a=PUjeQqilurYA:10 a=jCX6CI3P4pcA:10 a=cahJxx6UZF3xCAIBq47FAQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 69.204.222.235
Subject: Re: [PATCH][RFC] jump_labels/x86: Use either 5 byte or 2 byte jumps
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Richard Henderson <rth@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org
Date: Fri, 07 Oct 2011 18:00:51 -0400
In-Reply-To: <4E8F73A3.5080904@zytor.com>
References: <4E8CF385.2080804@zytor.com> <4E8DEB19.1050509@goop.org>
	  <20111006181055.GA2505@redhat.com>
	  <1317925615.4729.14.camel@gandalf.stny.rr.com>
	  <4E8DF870.6010000@redhat.com>
	  <1317929321.4729.17.camel@gandalf.stny.rr.com> <4E8E20CD.5030207@goop.org>
	  <1317938775.4729.29.camel@gandalf.stny.rr.com> <4E8E275F.6010801@goop.org>
	  <1318007374.4729.58.camel@gandalf.stny.rr.com>
	  <20111007185214.GD2978@redhat.com>
	 <1318015311.4729.69.camel@gandalf.stny.rr.com> <4E8F73A3.5080904@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318024853.4729.88.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 14:48 -0700, H. Peter Anvin wrote:
> On 10/07/2011 12:21 PM, Steven Rostedt wrote:
> >>
> >> same here, at least WARN, more likely BUG()
> >
> > I just don't like using BUG(). BUG() means that if we continue we will
> > corrupt the filesystem or make you go blind. WARN and returning here
> > should not cause any harm and will even let those with X terminals see
> > oops in /var/log/messages.
> >
> 
> Uh, NO.
> 
> If this is wrong something in the kernel code stream is corrupted (heck, 
> you might just have caught a rootkit!)
> 
> Die.  NOW.

Ouch, quite shaken by k.org? I guess I should have substituted go blind
with being hacked.


The thing is, it may be as simple as an out of tree module screwing up
the jump table. Or worse, gcc not doing things that we did not expect.
If this is the case, jump labels can be disabled from modifying code.

But if we just want to do the BUG() case, this will be a big hammer to
the code and we just prevent any further progress until the issue is
addressed. Which may be tell people to disable jump labels in their
code, or use a different compiler.

Currently ftrace takes the approach to WARN() and disable itself when it
finds an anomaly from what it expects to modify. The times this has
triggered has been either a problem with writing to the code, due to
securities preventing code modification, or the scan of the relocation
tables mistook a data point as code. The later I could foresee happening
with jump labels.

-- Steve


