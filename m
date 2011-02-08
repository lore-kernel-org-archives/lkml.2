Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1BHS2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 13:28:18 -0500
Received: from smtp-out.google.com ([74.125.121.67]:1232 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab1BHS2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 13:28:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mxEhElBta2/03vUvVhUC+ZUX79bXj6FFREhqVmeq3Eg4/jcyYGuKPs3BB9RKb63oHl
         8wv+5GZ9YY+4LMcMpQ4g==
MIME-Version: 1.0
In-Reply-To: <1297126056-14322-2-git-send-email-walken@google.com>
References: <1297126056-14322-1-git-send-email-walken@google.com>
	<1297126056-14322-2-git-send-email-walken@google.com>
Date: Tue, 8 Feb 2011 10:28:12 -0800
Message-ID: <AANLkTi=iYQCmKsE_xR4x0h-6BiVkpD3R2y6pKa1b9K0+@mail.gmail.com>
Subject: Re: [PATCH 1/2] mlock: fix race when munlocking pages in do_wp_page()
From: Hugh Dickins <hughd@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 4:47 PM, Michel Lespinasse <walken@google.com> wrote:
>
> vmscan can lazily find pages that are mapped within VM_LOCKED vmas,
> and set the PageMlocked bit on these pages, transfering them onto the
> unevictable list. When do_wp_page() breaks COW within a VM_LOCKED vma,
> it may need to clear PageMlocked on the old page and set it on the
> new page instead.
>
> This change fixes an issue where do_wp_page() was clearing PageMlocked on
> the old page while the pte was still pointing to it (as well as rmap).
> Therefore, we were not protected against vmscan immediately trasnfering
> the old page back onto the unevictable list. This could cause pages to
> get stranded there forever.
>
> I propose to move the corresponding code to the end of do_wp_page(),
> after the pte (and rmap) have been pointed to the new page. Additionally,
> we can use munlock_vma_page() instead of clear_page_mlock(), so that
> the old page stays mlocked if there are still other VM_LOCKED vmas
> mapping it.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: Hugh Dickins <hughd@google.com>

(but I have to say, do_wp_page() grows even ughlier!)
