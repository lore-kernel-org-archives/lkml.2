Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab1DHObm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:31:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:48252 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098Ab1DHObk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:31:40 -0400
Message-ID: <4D9F1CD1.2020600@suse.de>
Date: Fri, 08 Apr 2011 07:33:53 -0700
From: Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux Products GmbH
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Jon Masters <jcm@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device names
 in Kernel.
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp> <20110405161400.GA885@kroah.com> <4D9F17DF.5030601@hitachi.com>
In-Reply-To: <4D9F17DF.5030601@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2011 07:12 AM, Nao Nishijima wrote:
> Hi,
> 
> (2011/04/06 1:14), Greg KH wrote:
>> On Tue, Apr 05, 2011 at 09:49:46PM +0900, Nao Nishijima wrote:
>>> This patch series provides a SCSI option for persistent device
>>> names in kernel. With this option, user can always assign a
>>> same device name (e.g. sda) to a specific device according to
>>> udev rules and device id.
>>>
>>> Issue:
>>> Recently, kernel registers block devices in parallel. As a result,
>>> different device names will be assigned at each boot time. This
>>> will confuse file-system mounter, thus we usually use persistent
>>> symbolic links provided by udev.
>>
>> Yes, that is what you should use if you care about this.
>>
>>> However, dmesg and procfs outputs
>>> show device names instead of the symbolic link names. This causes
>>> a serious problem when managing multiple devices (e.g. on a
>>> large-scale storage), because usually, device errors are output
>>> with device names on dmesg.
>>
>> Then fix your tools that read the output of these files to point to the
>> proper persistent name instead of trying to get the kernel to solve the
>> problem.
>>
> 
> Yes, the tools should be revised if users get a device name using them.
> 
> The problem I would like to discuss here is that users can not identify
> a disk from kernel messages when they DIRECTLY refer to these messages.
> For example, a device name is used instead of a symbolic link names in
> bootup messages, I/O devices errors and /proc/partitions …etc.
> 
> In particular, users can not identify an appropriate device from a
> device name in syslog since different device name may be assigned to it
> at each boot time.
> 
> My idea is able to fix this issue with small changes in scsi subsystem.
> Also, it is implemented as an option. Therefore, it does not affect
> users who do not select this option.
> 
We have been discussing this problem several times in the past, and
indeed on these very mailing list.

The conclusion we arrived at is that the kernel-provided device node
name is inherently unstable and impossible to fix within the existing
'sdX' naming scheme.
So the choices have been to either move to a totally different naming
scheme or keep the naming scheme and provide the required information
by other means.
We have decided on the latter, and agreed on using udev to provide
persistent device names.
We are fully aware that any kernel related messages are subject to
chance after reboot, but then most kernel related messages are
(PID number, timestamps, login tty etc).
And also we are aware that any kernel messages need to be matched
against the current system layout to figure out any hardware-related
issue.

But then basically all products requiring to filter out information
from kernel messages already do so I don't see a problem with that.

Just adding an in-kernel identifier to the LUN will only be an
incomplete solution, as other identifiers will still be volatile.

So I would prefer by keeping the in-kernel information as small
as possible to reduce memory consumption and rely on out-of-band
programs to provide the required mapping.

Cheers,

Hannes
--
Dr. Hannes Reinecke              zSeries & Storage
hare@suse.de                  +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)


