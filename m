Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab0HPXkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 19:40:03 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33186 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0HPXkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 19:40:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, tglx@linutronix.de, mingo@redhat.com,
        vgoyal@redhat.com, nhorman@tuxdriver.com
References: <F0CB3B1C601247indou.takao@jp.fujitsu.com>
	<AANLkTimM0H0ryre3pXsXQ6c0e3=v_36-h0TsXzriMWXe@mail.gmail.com>
	<faf83501-1e53-459d-88ed-2ac5963a37f2@email.android.com>
	<AANLkTimtH41djAF5OxXCeVS8cHg_JCBd+wQ1iT1BUWgX@mail.gmail.com>
	<8f5e697c-e9ae-4453-aa7a-7086dd156cc9@email.android.com>
Date: Mon, 16 Aug 2010 16:39:51 -0700
In-Reply-To: <8f5e697c-e9ae-4453-aa7a-7086dd156cc9@email.android.com>
	(H. Peter Anvin's message of "Sun, 15 Aug 2010 22:08:43 -0700")
Message-ID: <m1ocd2i0u0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH][EFI] Run EFI in physical mode
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"H. Peter Anvin" <hpa@zytor.com> writes:
> "huang ying" <huang.ying.caritas@gmail.com> wrote:
>
>>On Mon, Aug 16, 2010 at 11:27 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> No, it should not be dynamic; rather we should unify all the users
>>> who need a 1:1 map and just keep that page table set around.

We still want to restore cr3 from the local task structure as soon
as is reasonable, as an identity mapped page table will have page 0
mapped and thus hide null pointer dereferences.

>>Agree. One known issue of global 1:1 map is that we need to make at
>>least part of page table PAGE_KERNEL_EXEC for EFI runtime code, and
>>change_page_attr can not be used before page allocator is available.

> For the 1:1 map we probably should make all pages executable; other
> things need it too, but we shouldn't have it mapped in except when
> needed.

We need to be careful in the setup of the global page table so that
we are in sync with the pat structure for the attributes pages
are mapped so that we don't map a page as cached and uncached
at the same time.  Otherwise we could accidentally get cache
corruption.  To do that would seem to mean change_page_attr
is relevant at least after we switch from our default set of
page permissions.

Eric
