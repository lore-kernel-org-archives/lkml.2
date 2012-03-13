Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab2CMMMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:12:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab2CMMMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:12:46 -0400
Message-ID: <4F5F39B9.1090109@redhat.com>
Date: Tue, 13 Mar 2012 13:12:41 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jan Kratochvil <jan.kratochvil@redhat.com>
CC: Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
References: <4F5A3A4D.1020008@redhat.com> <20120309172934.GA18173@host2.jankratochvil.net> <4F5DE6A4.2030303@redhat.com> <20120312165359.GA32400@host2.jankratochvil.net> <4F5E4757.705@redhat.com>
In-Reply-To: <4F5E4757.705@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 07:58 PM, Denys Vlasenko wrote:
> On 03/12/2012 05:53 PM, Jan Kratochvil wrote:
>> On Mon, 12 Mar 2012 13:05:56 +0100, Denys Vlasenko wrote:
>>> Why we don't save library names in coredump?
>>
>> Because they are useless.
>
> They may be useless in some situations. Not in every situation,
> by a long shot. Here is a live example from my system:
 >...

Another example. abrt project wants to do better duplicate detection
for coredumps, where duplicate is defined as "this crash is probably
caused by the same bug".

This needs to be done quickly. Downloading and installing debuginfos
are definitely out of the question.

Karel decided to do it by walking the stack and creating a simplified
backtrace of this form:

BUILD_ID OFFSET SYMBOL MODNAME

where
BUILD_ID: build id of the binary file the address is mapped to.
OFFSET: offset from the start of the executable section of the file
     the stored instruction pointer points to.
SYMBOL: name of the function if it is known.
MODNAME: name of the binary or library.

We wrote a small standalone tool which generates such trace.
The code we have now frequently generates something like this:

ec1fd70dbee0db36eff9527254d9d2bbfd260f13 0x34a7 close_stdout [exe]
ec1fd70dbee0db36eff9527254d9d2bbfd260f13 0x3dd8 close_stdout [exe]
ec1fd70dbee0db36eff9527254d9d2bbfd260f13 0x2093 - [exe]
ec1fd70dbee0db36eff9527254d9d2bbfd260f13 0x1659 - [exe]

Naturally, "[exe]" is there because we don't know executable names.
I have a new code which uses saved /proc/pid/maps and it generates:

ec1fd70dbee0db36eff9527254d9d2bbfd260f13 0x34a7 close_stdout /usr/bin/md5sum
ec1fd70dbee0db36eff9527254d9d2bbfd260f13 0x3dd8 close_stdout /usr/bin/md5sum
ec1fd70dbee0db36eff9527254d9d2bbfd260f13 0x2093 - /usr/bin/md5sum
ec1fd70dbee0db36eff9527254d9d2bbfd260f13 0x1659 - /usr/bin/md5sum

If anyone would want to use this tool on a large collection
of coredumps with the intent of fishing out similar crashes
(this is not a theoretical assumption, we *do* have people
who badly need this feature), they won't get nice names of binaries,
they'll get non-informative "[exe]" things - because /proc/pid/maps
info is not saved in coredump, and won't be available.
This will impair ability to perform crash similarity analysis.

-- 
vda

