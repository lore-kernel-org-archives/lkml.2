Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab2ISQxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:53:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44202 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272Ab2ISQxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:53:10 -0400
Message-ID: <5059F872.3080203@kdau.com>
Date: Wed, 19 Sep 2012 09:53:06 -0700
From: Kevin Daughtridge <kevin@kdau.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>
CC: Henrik Rydberg <rydberg@euromail.se>, Kevin Daughtridge <kevin@kdau.com>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: leave dev_rdesc unmodified and use it for comparisons
References: <50592FB1.7000800@kdau.com> <50597CAD.7010801@suse.cz>
In-Reply-To: <50597CAD.7010801@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/12 01:05 N.U., Jiri Slaby wrote:
> AFAICS this is incorrect. Some drivers return pointers to their own 
> static structure from their .report_fixup. Hence there are two problems:
> * leak, because kmemdup'ped start is never freed
> * invalid free -- kfree(device->rdesc) will try to free a static 
> structure regards, 

On 09/19/12 04:55 N.U., Jiri Kosina wrote:
> How do you avoid memory leak on 'start' here? 

Hmm. I hadn't noticed that the other drivers are returning a static 
structure. In that case, it seems that report_fixup itself is broken 
from a memory perspective, in that it returns pointers to inconsistent 
storage types depending on the driver. (As evidenced by how my first 
patch version would have also caused invalid frees that weren't evident 
from the declaration in hid.h.) I see two options:

1. Ugly workaround: make a temporary copy of the dev_rdesc, give it to 
report_fixup, make a copy of the return, store that copy in rdesc, free 
the temporary copy. Though ugly, this would at least involve the 
smallest diff.

2. Standardize the behavior of the drivers' report_fixup 
implementations. Given that some of them need to change the size of the 
descriptor, modifying the passed structure is not an option. Probably 
all of them should return a newly allocated structure, either a modified 
copy of the input or a copy of their static, that can then be stored 
directly in rdesc. Especially since report_fixup is only ever called 
right before a copy is going to be taken anyway. (Adding constness to a 
parameter isn't considered a severe ABI break, is it?)

Thoughts?

-Kevin
