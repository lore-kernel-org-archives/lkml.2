Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1AXRoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:44:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61824 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab1AXRoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:44:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FW6iLokIP41CVyGflvBHMYKrdnLYa6dOe9yhBf5OesiPqJuDGxNiUOfeemQJzKvhpC
         Dj7QBCxA8wa7k7Uo7ZKj5FEH9gNBZIuX00eF9POSdiwTbV/zOQDhalHmIw4/I2cnY61Y
         IayAAf1LKMltyvtD0Db00XU0WrJ40h+QtKkPo=
Message-ID: <4D3DBA6A.3080700@redhat.com>
Date: Mon, 24 Jan 2011 18:44:10 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@novell.com>,
        xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 08/23] xen: statically initialize cpu_evtchn_mask_p
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com> <1286898271-32018-9-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1286898271-32018-9-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2010 05:44 PM, Konrad Rzeszutek Wilk wrote:
> -static struct cpu_evtchn_s *cpu_evtchn_mask_p;
> +
> +static __initdata struct cpu_evtchn_s init_evtchn_mask = {
> +	.bits[0 ... (NR_EVENT_CHANNELS/BITS_PER_LONG)-1] = ~0ul,
> +};
> +static struct cpu_evtchn_s *cpu_evtchn_mask_p =&init_evtchn_mask;
> +
>   static inline unsigned long *cpu_evtchn_mask(int cpu)
>   {
>   	return cpu_evtchn_mask_p[cpu].bits;

This causes a modpost warning:

    WARNING: drivers/xen/built-in.o(.data+0x0): Section mismatch in
    reference from the variable cpu_evtchn_mask_p to the variable
    .init.data:init_evtchn_mask

    The variable cpu_evtchn_mask_p references
    the variable __initdata init_evtchn_mask

    If the reference is valid then annotate the
    variable with __init* or __refdata (see linux/init.h) or name the variable:
    *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

This is harmless, the variable is initialized to non-init data
in an __init function.  The added noise is ugly, though.

Paolo
