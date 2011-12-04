Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab1LDXi6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 18:38:58 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43623 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab1LDXi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 18:38:56 -0500
Subject: Re: [PATCH 1/2] ima: split ima_add_digest_entry() function
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmorris@namei.org
Date: Sun, 04 Dec 2011 18:36:02 -0500
In-Reply-To: <4ECA6595.7010406@polito.it>
References: <1321438229-18925-1-git-send-email-roberto.sassu@polito.it>
	 <1321450690.1901.24.camel@falcor> <4EC3CA9A.3070401@polito.it>
	 <4EC40682.2050602@linux.vnet.ibm.com> <4EC4E89F.2060608@polito.it>
	 <1321564518.21708.63.camel@falcor> <4EC63302.4040006@polito.it>
	 <1321637471.2158.44.camel@falcor> <4ECA6595.7010406@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323041763.2061.22.camel@falcor>
Mime-Version: 1.0
x-cbid: 11120423-2398-0000-0000-0000027F1132
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 15:52 +0100, Roberto Sassu wrote:
> On 11/18/2011 06:31 PM, Mimi Zohar wrote:
> > On Fri, 2011-11-18 at 11:27 +0100, Roberto Sassu wrote:
> >> On 11/17/2011 10:15 PM, Mimi Zohar wrote:
> >>> On Thu, 2011-11-17 at 11:57 +0100, Roberto Sassu wrote:
> >>>> On 11/16/2011 07:52 PM, Rajiv Andrade wrote:
> >>>>>
> >>>>> Thanks, Rajiv Andrade Security Development IBM Linux Technology Center
> >>>>>
> >>>>> On 16-11-2011 12:37, Roberto Sassu wrote:
> >>>>>> On 11/16/2011 02:38 PM, Mimi Zohar wrote:
> >>>>>>> On Wed, 2011-11-16 at 11:10 +0100, Roberto Sassu wrote:
> >>>>>>>> The ima_add_digest_entry() function has been split in order to avoid
> >>>>>>>> adding an entry in the measurements list for which the PCR extend
> >>>>>>>> operation subsequently fails. Required memory is allocated earlier
> >>>>>>>> in the
> >>>>>>>> new function ima_prepare_template_entry() and the template entry is
> >>>>>>>> added
> >>>>>>>> after ima_pcr_extend().
> >>>>>>>>
> >>>>>>>> Signed-off-by: Roberto Sassu<roberto.sassu@polito.it>
> >>>>>>>
> >>>>>>
> >>>>>> Hi Mimi
> >>>>>>
> >>>>>> i don't know if this condition can happen, but suppose that
> >>>>>> for whatever reason the PCR extend fails. In this case, since
> >>>>>> the PCR is not extended, the measurements list can be modified,
> >>>>>> by removing the non-measured entry, without this fact being
> >>>>>> detected by the verifier. So, probably we can avoid to display
> >>>>>> the entry.
> >>>>>>
> >>>>>>
> >>>>> Hi Roberto,
> >>>>>
> >>>>> IMA's trustworthiness is built on the assumption that the TPM underneath
> >>>>> can
> >>>>> be trusted. If that can't be, the eventlog alone doesn't provide us any
> >>>>> security.
> >>>>> It's the TPM device driver's job though to workaround any HW bug so that
> >>>>> in the
> >>>>> end all its stakeholders have their commands processed successfully, as
> >>>>> we've
> >>>>> pursued in some changes here:
> >>>>>
> >>>>
> >>>> Hi Rajiv
> >>>>
> >>>> thanks for your comments.
> >>>>
> >>>> I absolutely agree that we have to trust the TPM for the correct
> >>>> execution of IMA.
> >>>>
> >>>> I think the principle that has been used to build IMA (according
> >>>> to the TGC specifications) is that we can trust the eventlog
> >>>> as long as the measurement infrastructure is reliable or it is
> >>>> possible to detect a threat from previous measurements.
> >>>>
> >>>> For this reason, a system call is never executed before the
> >>>> inode measurement is inserted in the eventlog and the PCR
> >>>> is extended. Since these operations must be considered as
> >>>> atomic, their execution is protected by a mutex, that is
> >>>> released only after all tasks have been performed. This
> >>>> ensures that we begin with a measured kernel and we can
> >>>> reliably measure all further interactions. This also explains,
> >>>> in my view, why delaying the PCR extend operation may lead
> >>>> to security risks.
> >>>>
> >>>> About my patch, i did not move out the protected region any
> >>>> of the above described operations. Instead, i'm preventing
> >>>> measurements for which the PCR extend failed to be added to
> >>>> the measurements list, because in any case it is impossible
> >>>> for a verifier to detect their removal from the list.
> >>>>
> >>>> As i mentioned in the previous mail, one solution to overcome
> >>>> this issue is to deny, on the platform running IMA, the execution
> >>>> of those system calls for which the measurement process ended
> >>>> with an error.
> >>>>
> >>>> Regards
> >>>>
> >>>> Roberto Sassu
> >>>
> >>> True, if the TPM failed to extend the PCR, a malicious user would be
> >>> able to remove the measurement from the measurement list without it
> >>> being detected.  However, according to the TPM specs, the PCR extend
> >>> operation is always suppose to succeed, even in the case when the TPM is
> >>> not enabled.
> >>>
> >>
> >> Hi Mimi
> >>
> >> i don't know if this can happen, but, since the TPM always returns
> >> a result in its response, there may be particular conditions under
> >> which the PCR extend fails.
> >>
> >> After quickly looking at the code in 'drivers/char/tpm.c' there are
> >> some additional cases where the operation may fail. For instance,
> >> an operation may have been cancelled or it may have just reached the
> >> defined time limit.
> >>
> >>
> >>> More importantly we need to be able to detect when the PCR has not been
> >>> extended appropriately in order to address it.  Otherwise we're just
> >>> covering it up.
> >>>
> >>
> >> Probably i did not understand this point, but do the return code of
> >> tpm_pcr_extend() is not sufficient to determine if the operation was
> >> completed successfully?
> >>
> >> Roberto Sassu
> >
> > Your concern, that if the PCR extend fails, the PCR value will not match
> > the measurement list, is a valid concern. I'm not disagreeing with you
> > on this point.  At the same time, the IMA measurement policy defines
> > which files to include in the measurement list.  This policy is
> > independent of the TPM, whether it is enabled or not, or even if the TPM
> > is failing for some reason.  IMA goes into TPM by-pass mode and
> > maintains the measurement list on systems without a TPM.
> >
> 
> Hi Mimi
> 
> i think that if at some point IMA goes in TPM by-pass mode, this allows
> an attacker to hide malicious programs if they are measured after the
> switch.
> 
> So, i agree that an IMA user wants the complete measurements list for
> the corresponding policy, but i think it is also necessary to give
> verifiers the proof that the list contains exactly all events occurred
> in the platform to be attested, not only those for which the
> measurement process ended successfully.

Ok, so we agree that the IMA measurement list must include all
measurements based on policy and that either the verifier needs to be
able to detect TPM failure to extend the PCR with a measurement, or
that, as you suggest, the read/execute request itself is denied.

Unlike IMA-appraisal, which enforces file integrity, base IMA does not
interfere with the running system and should not deny read/execute
requests.

To validate the PCR against the measurement list, the verifier requests
a PCR quote and the measurement list. In the case of a peristent TPM
failure, the verifier won't be able to get a PCR quote.  For the
intermittent TPM failure case, in addition to going into TPM by-pass
mode, we could also prevent the TPM from quoting the IMA PCR.  This
would require some minor changes to the TPM device driver.

Mimi

