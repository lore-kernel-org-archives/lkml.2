Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab1FOBa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 21:30:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39257 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab1FOBa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 21:30:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF80B03.7000204@jp.fujitsu.com>
Date: Wed, 15 Jun 2011 10:29:39 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Avi Kivity <avi@redhat.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 2/2] x86, mce: rework use of TIF_MCE_NOTIFY
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>	<4df13cea27302b7ccf@agluck-desktop.sc.intel.com>	<20110612223840.GA23218@aftab>	<BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>	<4DF5C36A.1040707@redhat.com>	<20110613095521.GA26316@aftab>	<4DF5F729.4060609@redhat.com>	<20110613124003.GA27918@aftab>	<4DF606C9.90308@redhat.com>	<20110613151208.GA29045@aftab>	<4DF63B7A.1030805@redhat.com>	<BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com>	<4DF6CC58.8050601@jp.fujitsu.com>	<4DF6CD25.7040405@jp.fujitsu.com>	<BANLkTina_Y5xekoE9SnbG125CVFLopym2A@mail.gmail.com> <BANLkTimY1X73pTJmMd8G5GKpsCBVmXLfOw@mail.gmail.com>
In-Reply-To: <BANLkTimY1X73pTJmMd8G5GKpsCBVmXLfOw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/15 3:28), Tony Luck wrote:
> On Tue, Jun 14, 2011 at 11:02 AM, Tony Luck <tony.luck@intel.com> wrote:
>> need (failing address) to take some action. That was put into
>> the ring
> 
> Correction - we only put the pfn into the ring for AO (action optional)
> errors [in the current state of the patch series].
> 
> But the need for a path to get the pfn from the MC handler to the
> mce_notify_process() function remains the same.

Are there any reason why we cannot have a small special buffer for AR?
For example:

# writer side:
  for (i = 0; i < ar_buf_size; i++) {
    if (!cmpxchg(&ar_buf[i].pid, 0, current->pid)) {
      ar_buf[i].pfn = pfn;
      return 0;
    }
  }
  return -1; /* buffer full */

# reader side:
  for (i = 0; i < ar_buf_size; i++) {
    if (ar_buf[i].pid == current->pid) {
      mce_handle_srar(ar_buf[i].pfn);
      ar_buf[i].pid = 0;
    }
  }

I think it is not intrusive rather than having X-bytes for each thread,
which is usually 99.99% unused for its lifetime.

Or ... is it possible to push siginfo w/ addr and pop here?


Thanks,
H.Seto

