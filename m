Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab2DXQs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:48:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51432 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab2DXQs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:48:26 -0400
MIME-Version: 1.0
Date: Tue, 24 Apr 2012 12:48:25 -0400
Message-ID: <CAJoZ4U2bSzcpUjtuRq-8=02hShA62C6U7x6MGGOJLo39F8Gasw@mail.gmail.com>
Subject: MMU notifier callback in copy_page_range
From: Kyle Hubert <khubert@gmail.com>
To: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working on an RDMA driver that is maintaining secondary ptes. The
device then translates from it's own MMU into host physical pages.
This currently pins and unpins the pages around resource management.
However, I want to reserve a larger address space on behalf of the
application, and update ptes outside the resource acquisition. I did
this via an update API call, and then I call get_user_pages on the new
address (for a partial mapping). To allow for the application to unmap
memory from this larger address space without another special API
call, I hooked into the MMU notifier callbacks (invalidate_range_start
and invalidate_page) and call page_cache_release on the pages. This is
where I am running into trouble.

I see munmap works as expected, but fork is calling copy_page_range
which expects that the protection downgrade would require invalidating
the secondary ptes. The secondary MMU would then page fault due to
wrprotect, and call get_user_pages (with write flag) to get the
updated pte re-established. In my case, the secondary ptes get
unmapped and refcnts are decremented on the page. Due to the choice
for an update API call, this leaves the memory invalidated when
attempting to do an RDMA into the region, and thus getting a HW page
fault.

I am thinking about my options, and I was hoping for a little feedback.

1) Make a new API call to invalidate secondary ptes and release the pages.
2) Switch to invalidate_range_end and check for wrprotect, and if so,
ignore the call.
3) Switch to invalidate_range_end and check for a page count of 1, and
if so, free the page.
4) Listen for change_pte callbacks, and then break COW by explicitly
calling get_user_pages on the child MM. What happens to the parent
MM's pages, do they remain wrprotected?

My goal is to have memory setup for RDMA, and be able to survive a
fork call so the parent MM can still receive writes into the pages. Is
change_pte reliably called? I have trouble tracing do_wp_page..

Thanks for your help,
-Kyle Hubert
