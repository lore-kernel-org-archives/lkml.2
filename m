Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1DTBbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 21:31:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38042 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab1DTBbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=M8DdkeZehvtrOoqw3AO7sCus+onpKnE8q5nT2Zj/dxqgQbf+zAt86ZZiz8O6hNv1p6
         fRgGxQAMxRBrEBKT0DSQ==
Date: Tue, 19 Apr 2011 18:25:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: james_p_freyensee@linux.intel.com
cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com, christophe.guerard@intel.com
Subject: Re: [PATCH 3/4] Intel PTI implementaiton of MIPI 1149.7.
In-Reply-To: <1303253889-10074-4-git-send-email-james_p_freyensee@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1104191822440.8047@chino.kir.corp.google.com>
References: <james_p_freyensee@linux.intel.com> <1303253889-10074-4-git-send-email-james_p_freyensee@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011, james_p_freyensee@linux.intel.com wrote:

> +static void pti_control_frame_built_and_sent(struct pti_masterchannel *mc)
> +{
> +	struct pti_masterchannel mccontrol = {.master = CONTROL_ID,
> +					      .channel = 0};
> +	const char *control_format = "%3d %3d %s";
> +
> +	char comm[sizeof(current->comm) + 1];
> +	u8 control_frame[CONTROL_FRAME_LEN];
> +
> +	if (!in_interrupt())
> +		get_task_comm(comm, current);
> +	else
> +		strcpy(comm, "Interrupt");
> +
> +	/* Ensure our buffer is zero terminated */
> +	comm[sizeof(current->comm)] = 0;
> +

You definitely need to use get_task_comm() here, but that means you can't 
allocate char comm[] on the stack with anything but TASK_COMM_LEN, which 
is small enough that it shouldn't be an issue.  Otherwise there's nothing 
protecting sizeof(current->comm) from changing without holding 
task_lock(current).
