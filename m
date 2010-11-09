Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab0KIVZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:25:55 -0500
Received: from smtp-out.google.com ([74.125.121.35]:2499 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab0KIVZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:25:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=gIY7TvVEh5DlMJalfSdbltysLh9Iy1hRwv7sUhTOF+/m4CCbyhnpELFlRygad/lx2u
         uKJVuHwWo0JYo9a3cpPw==
Date: Tue, 9 Nov 2010 13:25:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Figo.zhang" <zhangtianfei@leadcoretech.com>,
        figo zhang <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH v2]oom-kill: CAP_SYS_RESOURCE should get bonus
In-Reply-To: <alpine.DEB.2.00.1011091300510.7730@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1011091319300.7730@chino.kir.corp.google.com>
References: <1288834737.2124.11.camel@myhost> <alpine.DEB.2.00.1011031847450.21550@chino.kir.corp.google.com> <20101109195726.BC9E.A69D9226@jp.fujitsu.com> <20101109122437.2e0d71fd@lxorguk.ukuu.org.uk>
 <alpine.DEB.2.00.1011091300510.7730@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, David Rientjes wrote:

> I didn't check earlier, but CAP_SYS_RESOURCE hasn't had a place in the oom 
> killer's heuristic in over five years, so what regression are we referring 
> to in this thread?  These tasks already have full control over 
> oom_score_adj to modify its oom killing priority in either direction.
> 

Yes, CAP_SYS_RESOURCE was a part of the heuristic in 2.6.25 along with 
CAP_SYS_ADMIN and was removed with the rewrite; when I said it "hasn't had 
a place in the oom killer's heuristic," I meant it's an unnecessary 
extention to CAP_SYS_ADMIN and allows for killing innocent tasks when a 
CAP_SYS_RESOURCE task is using too much memory.

The fundamental issue here is whether or not we should give a bonus to 
CAP_SYS_RESOURCE tasks because they are, by definition, allowed to access 
extra resources and we're willing to sacrifice other tasks for that.  This 
is antagonist to the oom killer's sole goal, however, which is to kill the 
task consuming the largest amount of memory unless protected by userspace 
(which CAP_SYS_RESOURCE has completely control in doing).

Since these threads have complete ability to give themselves this bonus 
(echo -30 > /proc/self/oom_score_adj), I don't think this needs to be a 
part of the core heuristic nor with such an arbitrary value of 3% (the old 
heuristic divided its badness score by 4, another arbitrary value).
