Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab1HHL72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:59:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63114 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1HHL70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:59:26 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Per Forlin" <per.forlin@linaro.org>
Cc: "Felipe Balbi" <balbi@ti.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH] usb: gadget: storage_common: make FSG_NUM_BUFFERS
 variable size
References: <1312762934-4884-1-git-send-email-per.forlin@linaro.org>
 <op.vzv2g7aa3l0zgt@mnazarewicz-glaptop>
 <CAJ0pr19edNL29ghqmAp_mwP0whoGZL_p1bQX23KaUsJGVDXQhg@mail.gmail.com>
Date: Mon, 08 Aug 2011 13:59:23 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vzv8w92p3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <CAJ0pr19edNL29ghqmAp_mwP0whoGZL_p1bQX23KaUsJGVDXQhg@mail.gmail.com>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Mon, 08 Aug 2011 02:22:14 +0200, Per Forlin wrote:
>>> There may not be one optimal number for all boards. That is the
>>> reason for adding the number to Kconfig,

> 2011/8/8 Michal Nazarewicz <mina86@mina86.com>:
>> It could actually be turned into a run-time configuration, but
>> that's a bit more intrusive,

On Mon, 08 Aug 2011 12:50:01 +0200, Per Forlin wrote:
> I consider this too but couldn't see how this would be done nicely.


In f_mass_storage.c, the buffers are stored in fsg_common structure
as an fixed size array.  Instead, this could be replaced by a pointer
and buffhds_count field with number of buffers.

The buffhds_count would have to initialised in fsg_common_init() from
a (new) field stored in fsg_config structure, which in turn in most
cases is filled by values from fsg_module_parameters which correspond
to module parameters defined in FSG_MODULE_PARAMATERS() macro.

The buffers are allocated in fsg_common_init() (see line 2815).  All
that would need to be change is to use value stored in fsg_common
instead of FSG_NUM_BUFFERS and first allocate space for the
common->buffhds array.

Similarly, fsg_common_realese() would have to get the number of
buffers from fsg_common structure and free common->buffhds after
freeing each individual buffers.

As far as I can tell, other places where FSG_NUM_BUFFERS is used
would be a simple s/FSG_NUM_BUFFERS/common->buffhds_count/g.


If you also care about file_storage.c, almost the same expect the
module parameter juggling is a bit easier.


But as I've said previously, it's not like I'm saying that's the way
it should be done right now.  I'm just describing how it could be
done should someone need to be able to change number of buffers via
module parameter rather then recompiling the module.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
