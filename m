Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab2AIRGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:06:03 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43445 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab2AIRGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:06:01 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        hch@infradead.org, akpm@linux-foundation.org
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
	<CA+55aFy-XiMR6XCudvjbPV8Q0cyDxy+iB_BnDxYOJTnskCkw9A@mail.gmail.com>
Date: Mon, 09 Jan 2012 18:05:32 +0100
In-Reply-To: <CA+55aFy-XiMR6XCudvjbPV8Q0cyDxy+iB_BnDxYOJTnskCkw9A@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 9 Jan 2012 08:43:32 -0800")
Message-ID: <877h10957n.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Jan 9, 2012 at 2:58 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> This patch adds a new dentry flag that is set when the dentry is removed
>> from the lru and put on the list being processed by
>> shrink_dentry_list().  The flag is cleared in dentry_lru_del() which is
>> called if the dentry gets a new reference just before it's pruned.
>>
>> Thoughts?
>
> Looks reasonable. Were you actually able to reproduce the hang, or how
> did you notice?

We got a bug report from a partner about hang during reboot.  It's
actually quite easily reproducible with:

while true; do
        echo -bond0 > /sys/class/net/bonding_masters
        echo +bond0 > /sys/class/net/bonding_masters
        echo -bond1 > /sys/class/net/bonding_masters
        echo +bond1 > /sys/class/net/bonding_masters
done

That reliably triggers the soft lookup detector for several machines
that we tested.  It's rather timing sensitive though, because turning on
DEBUG_SPINLOCK makes it go away.

I had to add printks to see what's going on, because it wasn't obvious
from the stack traces and crash dumps.

Thanks,
Miklos
