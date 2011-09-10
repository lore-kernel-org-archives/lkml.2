Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181Ab1IJLVA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 07:21:00 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:40501 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab1IJLU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 07:20:59 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: Why I want PTRACE_O_TRACESTOP option
Date: Sat, 10 Sep 2011 12:20:54 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.7.0; x86_64; ; )
Cc: "Indan Zupancic" <indan@nul.nu>, "Oleg Nesterov" <oleg@redhat.com>,
        "Tejun Heo" <tj@kernel.org>, "Denys Vlasenko" <dvlasenk@redhat.com>,
        linux-kernel@vger.kernel.org
References: <1315500802.18043.45.camel@dhcp-25-63.brq.redhat.com> <e7392891fba13321668f533c6a0d637b.squirrel@webmail.greenhost.nl> <201109100317.03979.vda.linux@googlemail.com>
In-Reply-To: <201109100317.03979.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109101220.54577.pedro@codesourcery.com>
X-OriginalArrivalTime: 10 Sep 2011 11:20:57.0257 (UTC) FILETIME=[B6206990:01CC6FAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 September 2011 02:17:03, Denys Vlasenko wrote:
> On Saturday 10 September 2011 01:09, Indan Zupancic wrote:
> > On Fri, September 9, 2011 18:26, Oleg Nesterov wrote:
> > > On 09/09, Indan Zupancic wrote:
> > >>
> > >> It is very useful to set options atomically at SEIZE time.
> > >
> > > Nobody argues with this.
> > >
> > >> Another important reason to make PTRACE_O_TRACESTOP an option is
> > >> because not everyone uses SEIZE: Users using PTRACE_TRACEME can't
> > >> set this option at all.
> > >
> > > Yes. This was already discussed, PTRACE_TRACEME obviously doesn't
> > > work if you need the new features. So far it was decided TRACEME
> > > should be avoided,
> > 
> > How do you want to attach/seize a just forked child without races
> > in a less ugly way than with TRACEME?
> 
> I needed to do it when I was adding usage of SEIZE to strace.
> It goes like this:
> 
> - fork
> - child: raise(SIGSTOP)
> - parent: waits until it sees child stopping
> - parent: seizes the child
> - parent: kill(child, SIGCONT)

You can do without SIGSTOP/signals:

- pipe
- fork
- child: block reading pipe
- parent: seizes the child
- parent: whatever else needs doing (e.g, interrupt and set options if not already done at seize time)
- parent: close the pipe
- child: notices pipe closed, moves on.

GDB already does something similar for other OSs (darwin/OSX, ttrace/HP-UX).

-- 
Pedro Alves
