Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab0FASgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 14:36:25 -0400
Received: from smtp-out.google.com ([74.125.121.35]:56212 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab0FASgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 14:36:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=TnJWJ3VJfq5ap1Gnz3KLY0DD7vOaJkamqLSBRju8yCeMOoa9sIneArsiI2TCHCZy+
	djU6gybBke5YkTbOYSHLw==
Date: Tue, 1 Jun 2010 11:36:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
In-Reply-To: <AANLkTil5gnDaVt9FXtGnPgQQQ2XLl4MYbNS_hsjdcsVa@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1006011132130.32024@chino.kir.corp.google.com>
References: <20100528152842.GH11364@uudg.org> <20100528154549.GC12035@barrios-desktop> <20100528164826.GJ11364@uudg.org> <20100531092133.73705339.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTikFk_HnZWPG0s_VrRkro2rruEc8OBX5KfKp_QdX@mail.gmail.com>
 <20100531140443.b36a4f02.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTil75ziCd6bivhpmwojvhaJ2LVxwEaEaBEmZf2yN@mail.gmail.com> <20100531145415.5e53f837.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTilcuY5e1DNmLhUWfXtiQgPUafz2zRTUuTVl-88l@mail.gmail.com>
 <20100531155102.9a122772.kamezawa.hiroyu@jp.fujitsu.com> <20100531135227.GC19784@uudg.org> <AANLkTil5gnDaVt9FXtGnPgQQQ2XLl4MYbNS_hsjdcsVa@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010, Minchan Kim wrote:

> Secondly, as Kame pointed out, we have to raise whole thread's
> priority to kill victim process for reclaiming pages. But I think it
> has deadlock problem.

Agreed, this has the potential to actually increase the amount of time for 
an oom killed task to fully exit: the exit path takes mm->mmap_sem on exit 
and if that is held by another thread waiting for the oom killed task to 
exit (i.e. reclaim has failed and the oom killer becomes a no-op because 
it sees an already killed task) then there's a livelock.  That's always 
been a problem, but is compounded with increasing the priority of a task 
not holding mm->mmap_sem if the thread holding the writelock actually 
isn't looking for memory but simply doesn't get a chance to release 
because it fails to run.
