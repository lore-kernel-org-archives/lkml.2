Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab1FFLCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:02:39 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40690 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab1FFLCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:02:39 -0400
Message-ID: <4DECB3B9.6040801@in.ibm.com>
Date: Mon, 06 Jun 2011 16:32:17 +0530
From: Suzuki Poulose <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Simon Horman <horms@verge.net.au>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] powerpc: Use the #address-cells information to parse
 memory/reg
References: <4DC923C4.6080707@in.ibm.com> <4DC92784.2040001@in.ibm.com> <20110510134152.GB18537@in.ibm.com>	<4DCA285D.2080006@in.ibm.com> <4DE3396E.4090801@in.ibm.com>	<4DEC7F49.8060000@in.ibm.com> <4DEC950E.1020105@linutronix.de>
In-Reply-To: <4DEC950E.1020105@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/11 14:21, Sebastian Andrzej Siewior wrote:
> Suzuki Poulose wrote:
>> Could you please let me know your thoughts/comments about this patch ?
>
> I'm mostly fine with it.
>
> Maaxim copied fs2dt.c from ppc64 to ppc. So I guess ppc64 has the same
> problem.

Yes, you are right. Porting this patch over to ppc64 is in my TODO list.

> ARM and MIPS is soon having DT support and kexec is probably also
> on their list so I would hate to see them to either copy the DT parsing
> file or having their own implementation.
>
> Maybe we should try to use libfdt for dt parsing. It has /proc import
> support so it should be fine for our needs. It is already in tree and used
> by ppc32 if a basic dtb is specified. I'm not sure if the /proc interface
> is part of dtc or libfdt.
>
> I'm not saying this has to be done now but maybe later before ARM and/or
> MIPS comes along needs something similar for their needs. If the libfdt is
> too complex for sucking in the dtb from /proc then maybe something else
> that generic and can be shared between booth ppc architectures and the
> other ones.
OK

>>> Index: kexec-tools-2.0.4/kexec/arch/ppc/kexec-ppc.c
>>> ===================================================================
>>> --- kexec-tools-2.0.4.orig/kexec/arch/ppc/kexec-ppc.c
>>> +++ kexec-tools-2.0.4/kexec/arch/ppc/kexec-ppc.c
>>> @@ -34,6 +35,92 @@ unsigned int rtas_base, rtas_size;
>>> int max_memory_ranges;
>>> const char *ramdisk;
>>>
>>> +/*
>>> + * Reads the #address-cells and #size-cells on this platform.
>>> + * This is used to parse the memory/reg info from the device-tree
>>> + */
>>> +int init_memory_region_info()
>>> +{
>>> + size_t res = 0;
>>> + FILE *fp;
>>> + char *file;
>>> +
>>> + file = "/proc/device-tree/#address-cells";
>>> + fp = fopen(file, "r");
>>> + if (!fp) {
>>> + fprintf(stderr,"Unable to open %s\n", file);
>>> + return -1;
>>> + }
>>> +
>>> + res = fread(&dt_address_cells,sizeof(unsigned long),1,fp);
>>> + if (res != 1) {
>>> + fprintf(stderr,"Error reading %s\n", file);
>>> + return -1;
>>> + }
>>> + fclose(fp);
>>> + dt_address_cells *= sizeof(unsigned long);
>
> This should be sizeof(unsigned int). I know we on 32bit.
>
OK. I was using (unsigned long) to get the word size on the machine. Given
this code is duplicated in ppc64, thought of having a generic code which works
fine for all ppcXX. As you mentioned, if we go about moving to a single copy of
fdt code, using long would help us.

>>> + file = "/proc/device-tree/#size-cells";
>>> + fp = fopen(file, "r");
>>> + if (!fp) {
>>> + fprintf(stderr,"Unable to open %s\n", file);
>>> + return -1;
>>> + }
>>> +
>>> + res = fread(&dt_size_cells,sizeof(unsigned long),1,fp);
>>> + if (res != 1) {
>>> + fprintf(stderr,"Error reading %s\n", file);
>>> + return -1;
>>> + }
>>> + fclose(fp);
>>> + dt_size_cells *= sizeof(unsigned long);
>
> same here.

Thanks
Suzuki
