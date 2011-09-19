Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab1ISRtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 13:49:55 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:18237 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab1ISRty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:49:54 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1316454497!39001032!97
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Dan Carpenter <error27@gmail.com>
CC: "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 19 Sep 2011 12:49:48 -0500
Subject: RE: improper sparse warnings in linux kernel build?
Thread-Topic: improper sparse warnings in linux kernel build?
Thread-Index: AcxvenpO1HCDzap1QJu1+c1nQ/of3wHeCcbg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F39DAED50B@AUSP01VMBX24.collaborationhost.net>
References: <201109091541.28395.hartleys@visionengravers.com>
 <20110910052719.GC4807@mwanda>
In-Reply-To: <20110910052719.GC4807@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 09, 2011 10:27 PM, Dan Carpenter wrote:
> On Fri, Sep 09, 2011 at 03:41:28PM -0700, H Hartley Sweeten wrote:
>> I'm not really sure what the DEFINE_PER_CPU macro expands to so I'm not
>> sure if the 'static' in front is actually getting used or if sparse is just
>> confused.
>> 
>> Is this an actual problem in the linux kernel or is sparse just getting
>> tripped up by the DEFINE_PER_CPU macro?
>> 
>
> I don't have a kernel git archive handy, but probably sparse is
> correct.  Do a "make arch/x86/kernel/cpu/mcheck/mce_intel.i" and run
> sparse on the .i file to find the line number that complains.

Dan,

The DEFINE_PER_CPU line in that file gets expanded from:

static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);

To (line breaks added for readability):

static __attribute__((section(".discard"), unused)) char __pcpu_scope_mce_banks_owned;
extern __attribute__((section(".discard"), unused)) char __pcpu_unique_mce_banks_owned;
__attribute__((section(".discard"), unused)) char __pcpu_unique_mce_banks_owned;
__attribute__((section(".data..percpu" ""))) __attribute__((weak)) __typeof__(mce_banks_t) mce_banks_owned;


It looks like the static tag is getting correctly applied to the first variable,
__pcpu_scope_mce_banks_owned.  The second one, __pcpu_unique_mce_banks_owned, is
getting tagged extern by the macro so the next __pcpu_unique_mce_banks_owned is ok.
The last variable, mce_banks_owned, seems to be the problem.

mce_banks_owned appears to be the only variable actually used in the file. I'm not
sure what the other three are used for.

I think the only way to fix this is by creating a new DEFINE_PER_CPU macro 
(DEFINE_PER_CPU_STATIC or DEFINE_STATIC_PER_CPU?) that automatically adds the static
tags correctly.

Regards,
Hartley