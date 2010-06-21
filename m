Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab0FUPPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:15:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:7004 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab0FUPPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:15:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=Glifs6aKqt6eKRci7SfKvSbayVjM/HiNM1TFvfMJExiXZeING4kKr41cpsIRJy7C7P
         24MJAYvSzVENOKtRxRQLIQsxGelvALM1ZjBESUF4ojJ2n1HHjEmbp14RzaSQz3RCZvW7
         PhCtEr5bH5sXaWJSJop6BirU2uBuqZwgyoymQ=
Message-ID: <4C1F8217.5020909@gmail.com>
Date: Mon, 21 Jun 2010 17:15:35 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1rc2-2.2 Thunderbird/3.1
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: audit_tree: sleep inside atomic
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

stanse found a sleep inside atomic added by the following commit:
commit fb36de479642bc9bdd3af251ae48b882d8a1ad5d
Author: Eric Paris <eparis@redhat.com>
Date:   Thu Dec 17 20:12:05 2009 -0500

    audit: reimplement audit_trees using fsnotify rather than inotify

    Simply switch audit_trees from using inotify to using fsnotify for it's
    inode pinning and disappearing act information.

    Signed-off-by: Eric Paris <eparis@redhat.com>


In untag_chunk, there is
  spin_lock(&entry->lock);
  ...
  new = alloc_chunk(size);
  ...
  spin_unlock(&entry->lock);

with
static struct audit_chunk *alloc_chunk(int count)
{
  struct audit_chunk *chunk;
  ...
  chunk = kzalloc(size, GFP_KERNEL);

But this can sleep. How big the allocations are? Could it be ATOMIC or
moved outside the spinlock?

thanks,
-- 
js
