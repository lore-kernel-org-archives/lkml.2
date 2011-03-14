Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1CNUcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:32:52 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55810 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1CNUcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:32:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=UjOtusASIDe+R65G07H9UDfScTMOMyfav6GhBsaXx9SbJb0LB1rVNSmO/R6R4pAjHW
         LZnfRHh1zb7aGUjSwgYA==
Date: Mon, 14 Mar 2011 13:32:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Oleg Nesterov <oleg@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>,
        Frantisek Hrbata <fhrbata@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 for 2.6.38] oom: oom_kill_process: don't set TIF_MEMDIE
 if !p->mm
In-Reply-To: <AANLkTi=YnG7tYCSrCPTNSQANOkD2MkP0tMjbOyZbx4NG@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103141322390.31514@chino.kir.corp.google.com>
References: <20110303100030.B936.A69D9226@jp.fujitsu.com> <20110308134233.GA26884@redhat.com> <alpine.DEB.2.00.1103081549530.27910@chino.kir.corp.google.com> <20110309151946.dea51cde.akpm@linux-foundation.org> <alpine.DEB.2.00.1103111142260.30699@chino.kir.corp.google.com>
 <20110312123413.GA18351@redhat.com> <20110312134341.GA27275@redhat.com> <AANLkTinHGSb2_jfkwx=Wjv96phzPCjBROfCTFCKi4Wey@mail.gmail.com> <20110313212726.GA24530@redhat.com> <20110314190419.GA21845@redhat.com> <20110314190446.GB21845@redhat.com>
 <AANLkTi=YnG7tYCSrCPTNSQANOkD2MkP0tMjbOyZbx4NG@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Linus Torvalds wrote:

> The combination of testing PF_EXITING and p->mm just doesn't seem to
> make any sense.
> 

Right, it doesn't (and I recently removed testing the combination from 
select_bad_process() in -mm).  The check for PF_EXITING in the oom killer 
is purely to avoid needlessly killing tasks when something is already 
exiting and will (hopefully) be freeing its memory soon.  If an eligible 
thread is found to be PF_EXITING, the oom killer will defer indefinitely 
unless it happens to be current.  If it happens to be current, then it is 
automatically selected so it gets access to the needed memory reserves.

We do need to ensure that behavior doesn't preempt any task from being 
killed if there's an eligible thread other than current that never 
actually detaches its ->mm (oom-skip-zombies-when-iterating-tasklist.patch 
in -mm filters all threads without an ->mm).  That can happen if 
mm->mmap_sem never gets released by a thread and that's why an earlier 
change that is already in your tree automatically gives current access to 
memory reserves immediately upon calling the oom killer if it has a 
pending SIGKILL.
