Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1FFIvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:51:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:43969 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab1FFIvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:51:37 -0400
Message-ID: <4DEC950E.1020105@linutronix.de>
Date: Mon, 06 Jun 2011 10:51:26 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Suzuki Poulose <suzuki@in.ibm.com>
CC: Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] powerpc: Use the #address-cells information to parse
 memory/reg
References: <4DC923C4.6080707@in.ibm.com> <4DC92784.2040001@in.ibm.com> <20110510134152.GB18537@in.ibm.com> <4DCA285D.2080006@in.ibm.com> <4DE3396E.4090801@in.ibm.com> <4DEC7F49.8060000@in.ibm.com>
In-Reply-To: <4DEC7F49.8060000@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suzuki Poulose wrote:
> Could you please let me know your thoughts/comments about this patch ?

I'm mostly fine with it.

Maaxim copied fs2dt.c from ppc64 to ppc. So I guess ppc64 has the same
problem. ARM and MIPS is soon having DT support and kexec is probably also
on their list so I would hate to see them to either copy the DT parsing
file or having their own implementation.

Maybe we should try to use libfdt for dt parsing. It has /proc import
support so it should be fine for our needs. It is already in tree and used
by ppc32 if a basic dtb is specified. I'm not sure if the /proc interface
is part of dtc or libfdt.

I'm not saying this has to be done now but maybe later before ARM and/or
MIPS comes along needs something similar for their needs. If the libfdt is
too complex for sucking in the dtb from /proc then maybe something else
that generic and can be shared between booth ppc architectures and the
other ones.

> Thanks
> Suzuki
> 
>>
>> Index: kexec-tools-2.0.4/kexec/arch/ppc/kexec-ppc.c
>> ===================================================================
>> --- kexec-tools-2.0.4.orig/kexec/arch/ppc/kexec-ppc.c
>> +++ kexec-tools-2.0.4/kexec/arch/ppc/kexec-ppc.c
>> @@ -34,6 +35,92 @@ unsigned int rtas_base, rtas_size;
>> int max_memory_ranges;
>> const char *ramdisk;
>>
>> +/*
>> + * Reads the #address-cells and #size-cells on this platform.
>> + * This is used to parse the memory/reg info from the device-tree
>> + */
>> +int init_memory_region_info()
>> +{
>> + size_t res = 0;
>> + FILE *fp;
>> + char *file;
>> +
>> + file = "/proc/device-tree/#address-cells";
>> + fp = fopen(file, "r");
>> + if (!fp) {
>> + fprintf(stderr,"Unable to open %s\n", file);
>> + return -1;
>> + }
>> +
>> + res = fread(&dt_address_cells,sizeof(unsigned long),1,fp);
>> + if (res != 1) {
>> + fprintf(stderr,"Error reading %s\n", file);
>> + return -1;
>> + }
>> + fclose(fp);
>> + dt_address_cells *= sizeof(unsigned long);

This should be sizeof(unsigned int). I know we on 32bit.

>> + file = "/proc/device-tree/#size-cells";
>> + fp = fopen(file, "r");
>> + if (!fp) {
>> + fprintf(stderr,"Unable to open %s\n", file);
>> + return -1;
>> + }
>> +
>> + res = fread(&dt_size_cells,sizeof(unsigned long),1,fp);
>> + if (res != 1) {
>> + fprintf(stderr,"Error reading %s\n", file);
>> + return -1;
>> + }
>> + fclose(fp);
>> + dt_size_cells *= sizeof(unsigned long);

same here.

>> +
>> + return 0;
>> +}
>> +

Sebastian
