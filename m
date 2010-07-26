Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab0GZSOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 14:14:31 -0400
Received: from claw.goop.org ([74.207.240.146]:45058 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab0GZSOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 14:14:30 -0400
Message-ID: <4C4DD085.1030309@goop.org>
Date: Mon, 26 Jul 2010 11:14:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sheng Yang <sheng@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the final tree (xen
 tree related)
References: <20100726152908.951a95b7.sfr@canb.auug.org.au> <alpine.DEB.2.00.1007261132180.22235@kaball-desktop> <4C4DC505.9040202@goop.org> <alpine.DEB.2.00.1007261835360.19809@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1007261835360.19809@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/26/2010 10:57 AM, Stefano Stabellini wrote:
> On Mon, 26 Jul 2010, Jeremy Fitzhardinge wrote:
>>    On 07/26/2010 03:43 AM, Stefano Stabellini wrote:
>>> On Mon, 26 Jul 2010, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> After merging the final tree, today's linux-next build (i386 defconfig)
>>>> failed like this:
>>>>
>>>> arch/x86/built-in.o: In function `init_hypervisor_platform':
>>>> (.init.text+0x3ca4): undefined reference to `x86_hyper_xen_hvm'
>>>> arch/x86/built-in.o: In function `init_hypervisor_platform':
>>>> (.init.text+0x3cad): undefined reference to `x86_hyper_xen_hvm'
>>>>
>>>> Caused by commit bee6ab53e652a414af20392899879b58cd80d033 ("x86: early PV
>>>> on HVM features initialization").
>>>>
>>>> I reverted commit 4b9100d12d15c0eaf23d9edc86228e1bdf452dc2 ("Merge branch
>>>> 'upstream/pvhvm' into upstream/xen") for today (since there were
>>>> dependencies on the above commit).
>>> The problem is that x86_hyper_xen_hvm is in arch/x86/xen/enlighten.c,
>>> that is compiled only when CONFIG_XEN is enabled.
>>> The appended patch fixes the issue moving x86_hyper_xen_hvm to
>>> arch/x86/kernel/cpu/xen.c that is always compiled.
>>>
>>> An shorter alternative solution would be just to ifdef CONFIG_XEN
>>> x86_hyper_xen_hvm in arch/x86/kernel/cpu/hypervisor.c.
>> Seems like the most sensible thing to do.  What's the point in detecting
>> Xen if we don't have CONFIG_XEN enabled?
> There isn't much point in doing so apart from avoiding an ifdef.
> This is the alternative:

Thanks.  I'd already committed it ;)

     J

> ---
>
>
> Signed-off-by: Stefano Stabellini<stefano.stabellini@eu.citrix.com>
>
> diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
> index bffd47c..5bccedc 100644
> --- a/arch/x86/kernel/cpu/hypervisor.c
> +++ b/arch/x86/kernel/cpu/hypervisor.c
> @@ -34,7 +34,9 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
>   {
>   	&x86_hyper_vmware,
>   	&x86_hyper_ms_hyperv,
> +#ifdef CONFIG_XEN
>   	&x86_hyper_xen_hvm,
> +#endif
>   };
>
>   const struct hypervisor_x86 *x86_hyper;
>

