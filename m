Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab0FJUce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 16:32:34 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47634 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab0FJUcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 16:32:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=cAa0zFKdnK1aiamYitrbrI/sdRuNJDEYmOjbPslJjNdCSMWCshaOzOCwUrvGoskkj
	nLrKu6+X4WKdVfCMLb79w==
Date: Thu, 10 Jun 2010 13:32:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ryan Wang <openspace.wang@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kernelnewbies@nl.linux.org
Subject: Re: oom killer and long-waiting processes
In-Reply-To: <AANLkTik6xP9vVEyW4QG-4RfZu-iEuHcl2pBV_-mfHP4y@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1006101326440.20197@chino.kir.corp.google.com>
References: <AANLkTik6xP9vVEyW4QG-4RfZu-iEuHcl2pBV_-mfHP4y@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010, Ryan Wang wrote:

> Hi all,
> 
>         I have one question about oom killer:
> If many processes dealing with network communications,
> but due to bad network traffic, the processes have to wait
> for a very long time. And meanwhile they may consume
> some memeory separately for computation. The number
> of such processes may be large.
> 
>         I wonder whether oom killer will kill these processes
> when the system is under high pressure?
> 

The kernel can deal with "high pressure" quite well, but in some cases 
such as when all of your RAM or your memory controller is filled with 
anonymous memory and cannot be reclaimed, the oom killer may be called to 
kill "something".  It prefers to kill something that will free a large 
amount of memory to avoid having to subsequently kill additional tasks 
when it kills something small first.

If there are tasks that you'd either like to protect from the oom killer 
or always prefer in oom conditions, you can influence its decision-making 
from userspace by tuning /proc/<pid>/oom_adj of the task in question.  
Users typically set an oom_adj value of "-17" to completely disable oom 
killing of pid (the kernel will even panic if it can't find anything 
killable as a result of this!), a value of "-16" to prefer that pid gets 
killed last, and a value of "15" to always prefer pid gets killed first.

Lowering a /proc/<pid>/oom_adj value for a pid from its current value (it 
inherits its value from the parent, which is usually 0) is only allowed by 
root, more specifically, it may only be done by the CAP_SYS_RESOURCE 
capability.

You can refer to Documentation/filesystems/proc.txt for information on 
oom_adj.
