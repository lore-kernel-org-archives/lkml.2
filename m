Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab0JSSoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:44:09 -0400
Received: from smtp-out.google.com ([74.125.121.35]:50354 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab0JSSoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=uyGrpdxADXSlIzl4hTJKJumhhTKtKB7BKhRF17wnaE6PAXRldwpuKzESzLlIhxCfEL
         weQcMhE8qY2vYOAlnecw==
Date: Tue, 19 Oct 2010 11:43:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, figo1802 <figo1802@gmail.com>
Subject: Re: oom_killer crash linux system
In-Reply-To: <1287454058.2078.12.camel@myhost>
Message-ID: <alpine.DEB.2.00.1010191139480.8950@chino.kir.corp.google.com>
References: <20101018021126.GB8654@localhost> <1287389631.1997.9.camel@myhost> <20101018180919.3AF8.A69D9226@jp.fujitsu.com> <1287454058.2078.12.camel@myhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, Figo.zhang wrote:

> > very lots of change ;)
> > can you please send us your crash log?
> 
> i add some prink in select_bad_process() and oom_badness() to see
> pid/totalpages/points/memoryuseage/and finally process to selet to kill.
> 

It shouldn't need any printk's to be added, the new heuristic is rather 
predictable given the memory usage of the application.  You could find 
what the badness score is by checking /proc/pid/oom_score.

> i found it the oom-killer select: syslog-ng,mysqld,nautilus,VirtualBox
> to kill, so my question is:
> 
> 1. the syslog-ng,mysqld,nautilus is the system foundamental process, so
> if oom-killer kill those process, the system will be damaged, such as
> lose some important data.
> 

The oom killer always attempts to kill the most memory-hogging task that 
is eligible given the context in which the system is out of memory.  That 
allows the kernel to free a large amount of memory so the oom killer will 
not (hopefully) have to be recalled again in the near future.  Otherwise, 
we end up killing everything else other than the memory-hogger, and it 
that may turn out to be a memory leaker that we don't care about :)

> 2. the new oom-killer just use percentage of used memory as score to
> select the candidate to kill, but how to know this process to very
> important for system?
> 

The user has to tell it by using /proc/pid/oom_score_adj, see 
Documentation/filesystems/proc.txt if you'd like to adjust how the oom 
killer ranks tasks that you deem to be important and vital to your system.
