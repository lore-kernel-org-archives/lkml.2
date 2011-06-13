Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1FMFcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 01:32:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55739 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1FMFcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 01:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=m2mvNQNZscVhie5nolj6ilo/UO2F9cc3NqvTrHyI7YVVyji/nq29iUBVq8WQk9r2LN
         JX/NbEYz2gvHyCCiVR8LB6xpRRD8laZnNQfdmEl6+Mazy9330WpQyOYI9YrYaVhIDFPY
         JPY2g6mFYmvrOAxzwmaO8+uWg4LLWMfKlKqRY=
MIME-Version: 1.0
In-Reply-To: <20110612223840.GA23218@aftab>
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>
	<4df13cea27302b7ccf@agluck-desktop.sc.intel.com>
	<20110612223840.GA23218@aftab>
Date: Sun, 12 Jun 2011 22:31:58 -0700
X-Google-Sender-Auth: AV0KaZAbaHMjpk-TNv4Eg3nogxk
Message-ID: <BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>
Subject: Re: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 3:38 PM, Borislav Petkov <bp@amd64.org> wrote:
> On Thu, Jun 09, 2011 at 05:36:42PM -0400, Luck, Tony wrote:
>> From: Tony Luck <tony.luck@intel.com>
>>
>> Existing user return notifier mechanism is designed to catch a specific
>> cpu just as it returns to run any task in user mode.  We also need a
>> mechanism to catch a specific task.
>
> Why do we need that? I mean, in the remaining patches we end up either
> running memory_failure() or sending signals to a task. Can't we do it
> all in the user return notifier and not have a different notifier for
> each policy?

Unless I'm mis-reading the user-return-notifier code, it is possible that
we'll context switch before we get to the notifier. At that point the
user-return-notifier TIF bit is passed on from our task to the newly
run-able task. But our task is still viable, so another cpu could grab
it and start running it ... then we have a race ... will the new task
that inherited the notifier unmap the page fast enough, or will there
be a loud BANG as the original task runs right into the machine
check again.

-Tony
