Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab1DVR5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 13:57:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:6970 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756423Ab1DVR5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 13:57:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,254,1301900400"; 
   d="scan'208";a="682616109"
Subject: Re: [PATCH 3/4] Intel PTI implementaiton of MIPI 1149.7.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com, christophe.guerard@intel.com
In-Reply-To: <alpine.DEB.2.00.1104191822440.8047@chino.kir.corp.google.com>
References: <james_p_freyensee@linux.intel.com>
	 <1303253889-10074-4-git-send-email-james_p_freyensee@linux.intel.com>
	 <alpine.DEB.2.00.1104191822440.8047@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 22 Apr 2011 10:57:14 -0700
Message-ID: <1303495034.13457.121.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 18:25 -0700, David Rientjes wrote:
> On Tue, 19 Apr 2011, james_p_freyensee@linux.intel.com wrote:
> 
> > +static void pti_control_frame_built_and_sent(struct pti_masterchannel *mc)
> > +{
> > +	struct pti_masterchannel mccontrol = {.master = CONTROL_ID,
> > +					      .channel = 0};
> > +	const char *control_format = "%3d %3d %s";
> > +
> > +	char comm[sizeof(current->comm) + 1];
> > +	u8 control_frame[CONTROL_FRAME_LEN];
> > +
> > +	if (!in_interrupt())
> > +		get_task_comm(comm, current);
> > +	else
> > +		strcpy(comm, "Interrupt");
> > +
> > +	/* Ensure our buffer is zero terminated */
> > +	comm[sizeof(current->comm)] = 0;
> > +
> 
> You definitely need to use get_task_comm() here, but that means you can't 
> allocate char comm[] on the stack with anything but TASK_COMM_LEN, which 
> is small enough that it shouldn't be an issue.  Otherwise there's nothing 
> protecting sizeof(current->comm) from changing without holding 
> task_lock(current).

I'm going to look at utilizing get_task_comm() more in this function,
but I think I am okay even if I miss one, as I am just doing a read from
it.  What is written in set_task_comm() states that threads may read
from current->comm without holding the task_lock().  The name could be
incomplete, which would be non-ideal (but acceptable), but it's supposed
to be safe from non-terminating string reads.

And it seems like the fix for

> + comm[sizeof(current->comm)] = 0;

can just be comm[TASK_COMM_LEN].

