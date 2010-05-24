Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab0EXLYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 07:24:43 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:45703 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab0EXLYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 07:24:42 -0400
Message-ID: <4BFA61F4.1010203@cesarb.net>
Date: Mon, 24 May 2010 08:24:36 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: Swap checksum
References: <4BF81D87.6010506@cesarb.net> <1274551731-4534-3-git-send-email-cesarb@cesarb.net> <4BF94792.5030405@redhat.com> <4BF97AC2.1040505@cesarb.net> <4BFA1F92.2080802@redhat.com>
In-Reply-To: <4BFA1F92.2080802@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-05-2010 03:41, Avi Kivity escreveu:
> On 05/23/2010 09:58 PM, Cesar Eduardo Barros wrote:
>> One possibility could be to compare the full page against zero only if
>> its crc is a specific value (the crc32c of a page full of zeros). This
>> would not be too slow (we would be wasting time only when we have a
>> very high probability of saving much more time), and not need to touch
>> the crc32c code at all. I would only have to look at how this messes
>> up the state tracking (i.e. how to make it track the fact that,
>> instead of getting written out, this is now a zeroed page).
>
> Instead of returning a swap pte to be written to the page tables, return
> a zeroed pte.

Unfortunately, at this point in the code (swap_writepage) it is not a 
matter of simply returning a zeroed pte; it would have to go looking for 
the page tables.

If I am understanding things correctly, in some situations even looking 
for them via the struct page I have and its rmap stuff is not enough; 
you could have a pte still pointing to the swap instead of pointing to 
the page (which when faulted would go via the swap cache to get the page).

For instance, if the page was shared between several processes, got 
swapped out, swapped in but accessed only by some of the processes, and 
in the process of being swapped out again.

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
