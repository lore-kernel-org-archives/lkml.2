Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab0JAEr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 00:47:26 -0400
Received: from freeflow.nu ([178.79.134.28]:46273 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab0JAErZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 00:47:25 -0400
Message-ID: <4CA567DB.4000208@kernel.org>
Date: Fri, 01 Oct 2010 07:47:23 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, dave@gnu.org, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: [RESEND PATCH] cpufreq: unnecesary double free in pcc_cpufreq_do_osc
References: <1285875804.2180.1.camel@cowboy> <AANLkTikbSYutRGwQLU2srEQG6CO7pvXdFBQ0W216DoCv@mail.gmail.com> <20100930200617.GA4120@redhat.com>
In-Reply-To: <20100930200617.GA4120@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Dave,

On 30.9.2010 23.06, Dave Jones wrote:
> On Thu, Sep 30, 2010 at 10:59:51PM +0300, Pekka Enberg wrote:
>   >  >  +++ b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
>   >  >  @@ -379,6 +379,8 @@ static int __init pcc_cpufreq_do_osc(acpi_handle *handle)
>   >  >          if (!(supported&  0x1))
>   >  >                  return -ENODEV;
>   >  >
>   >  >  +       return ret;
>   >  >  +
>   >  >    out_free:
>   >  >          kfree(output.pointer);
>   >  >          return ret;
>   >
>   >  Where is the double free here? I can't see it. I do see memory leaks
>   >  happening in error handling paths of pcc_cpufreq_do_osc() which makes
>   >  me think we need something like the attached patch.
>
> I think Dave's patch is correct.  There's a kfree(output.pointer) at line 359.
> If we fall all the way through without hitting any of the return -ENODEVs,
> we end up doing a 2nd kfree in the out_free:

There's a second call to acpi_evaluate_object() which takes "output" as 
its argument and allocates more memory.
