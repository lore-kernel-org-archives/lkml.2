Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab2FTJ4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:56:22 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45706 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab2FTJ4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:56:18 -0400
Date: Wed, 20 Jun 2012 11:56:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120620095616.GB10012@aftab.osrc.amd.com>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
 <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <1340182778.21745.75.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340182778.21745.75.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 10:59:38AM +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-20 at 01:28 +0200, Borislav Petkov wrote:
> > 
> > which makes me wonder whether we still need that OLD INTERFACE.
> > Henrique, any thoughts here? 
> 
> Yes I need it, I've no f'ing clue where to put the ucode image so that
> the whole firmware mess can find it :-)

On AMD:

static enum ucode_state request_microcode_amd(int cpu, struct device *device)
{
        char fw_name[36] = "amd-ucode/microcode_amd.bin";
        const struct firmware *fw;
        enum ucode_state ret = UCODE_NFOUND;
        struct cpuinfo_x86 *c = &cpu_data(cpu);

        if (c->x86 >= 0x15)
                snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
	...


On Intel:

static enum ucode_state request_microcode_fw(int cpu, struct device *device)
{
        char name[30];
        struct cpuinfo_x86 *c = &cpu_data(cpu);
        const struct firmware *firmware;
        enum ucode_state ret;

        sprintf(name, "intel-ucode/%02x-%02x-%02x",
                c->x86, c->x86_model, c->x86_mask);

	...

And that's all under /lib/firmware/

Phew, now that Peter is converted, we can kill the old interface too :-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
