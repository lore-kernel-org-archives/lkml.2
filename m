Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab1KILLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:11:19 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:29263 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1KILLR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:11:17 -0500
X-IronPort-AV: E=Sophos;i="4.69,483,1315180800"; 
   d="scan'208";a="8836858"
From: Paul Durrant <Paul.Durrant@citrix.com>
To: "annie.li@oracle.com" <annie.li@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>
CC: "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Date: Wed, 9 Nov 2011 11:11:22 +0000
Subject: RE: [PATCH 1/3] Introducing grant table V2 stucture
Thread-Topic: [PATCH 1/3] Introducing grant table V2 stucture
Thread-Index: Acyet8ZYqfvoa7PvSFarsEFl6ZbbZQAFzQUg
Message-ID: <291EDFCB1E9E224A99088639C4762022B4543AB1BD@LONPMAILBOX01.citrite.net>
References: <4EBA35D3.3020506@oracle.com>
 <1320826490-29362-1-git-send-email-annie.li@oracle.com>
In-Reply-To: <1320826490-29362-1-git-send-email-annie.li@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annie,

  Comments inline below...

> -----Original Message-----
[snip]
> -static struct grant_entry *shared;
> +static union {
> +	struct grant_entry_v1 *v1;
> +	void *ring_addr;
> +} shared;
> +

'ring_addr' seems like the wrong name here; how about 'raw'?

> +/*
> + * This function is null for grant table v1, adding it here in
> order to
> +keep
> + * consistent with *_v2 interface.
> + */
> +static int gnttab_map_status_v1(unsigned int nr_gframes);
> +/*
> + * This function is null for grant table v1, adding it here in
> order to
> +keep
> + * consistent with *_v2 interface.
> + */
> +static void gnttab_unmap_status_v1(void);
> +

I don't really like the idea of having null operations. How about abstracting at the level of gnttab_map/unmap so that you can include the status mapping for v2 but just do the arch_gnttab_map_shared for v1?

> +/*This is a structure of function pointers for grant table v1*/
> static
> +struct {
> +	/*
> +	 * Mapping a list of frames for storing grant entry status,
> this
> +	 * mechanism can allow better synchronization using barriers.
> Input
> +	 * parameter is frame number, returning GNTST_okay means
> success and
> +	 * negative value means failure.
> +	 */
> +	int (*_gnttab_map_status)(unsigned int);
> +	/*
> +	 * Release a list of frames which are mapped in
> _gnttab_map_status for
> +	 * grant entry status.
> +	 */
> +	void (*_gnttab_unmap_status)(void);
> +	/*
> +	 * Introducing a valid entry into the grant table, granting
> the frame
> +	 * of this grant entry to domain for accessing, or
> transfering, or
> +	 * transitively accessing. First input parameter is reference
> of this
> +	 * introduced grant entry, second one is domid of granted
> domain, third
> +	 * one is the frame to be granted, and the last one is status
> of the
> +	 * grant entry to be updated.
> +	 */
> +	void (*_update_grant_entry)(grant_ref_t, domid_t,
> +		unsigned long, unsigned);
> +	/*
> +	 * Stop granting a grant entry to domain for accessing. First
> input
> +	 * parameter is reference of a grant entry whose grant access
> will be
> +	 * stopped, second one is not in use now. If the grant entry
> is
> +	 * currently mapped for reading or writing, just return
> failure(==0)
> +	 * directly and don't tear down the grant access. Otherwise,
> stop grant
> +	 * access for this entry and return success(==1).
> +	 */
> +	int (*_gnttab_end_foreign_access_ref)(grant_ref_t, int);
> +	/*
> +	 * Stop granting a grant entry to domain for transfer. If
> tranfer has
> +	 * not started, just reclaim the grant entry and return
> failure(==0).
> +	 * Otherwise, wait for the transfer to complete and then
> return the
> +	 * frame.
> +	 */
> +	unsigned long
> (*_gnttab_end_foreign_transfer_ref)(grant_ref_t);
> +	/*
> +	 * Query the status of a grant entry. Input parameter is
> reference of
> +	 * queried grant entry, return value is the status of queried
> entry.
> +	 * Detailed status(writing/reading) can be gotten from the
> return value
> +	 * by bit operations.
> +	 */
> +	int (*_gnttab_query_foreign_access)(grant_ref_t);
> +} gnttab_interface;
> +

Why the leading '_' in the names?

> +static int grant_table_version;
> 
>  static struct gnttab_free_callback *gnttab_free_callback_list;
> 
> @@ -142,6 +207,15 @@ static void put_free_entry(grant_ref_t ref)
>  	spin_unlock_irqrestore(&gnttab_list_lock, flags);  }
> 
> +static void update_grant_entry_v1(grant_ref_t ref, domid_t domid,
> +				  unsigned long frame, unsigned flags) {
> +	shared.v1[ref].frame = frame;
> +	shared.v1[ref].domid = domid;
> +	wmb();
> +	shared.v1[ref].flags = flags;
> +}
> +
>  static void update_grant_entry(grant_ref_t ref, domid_t domid,
>  			       unsigned long frame, unsigned flags)  {
> @@ -155,12 +229,10 @@ static void update_grant_entry(grant_ref_t
> ref, domid_t domid,
>  	 *  3. Write memory barrier (WMB).
>  	 *  4. Write ent->flags, inc. valid type.
>  	 */

The comment above probably should be moved into the v1 function itself since the v2 code differs.

> -	shared[ref].frame = frame;
> -	shared[ref].domid = domid;
> -	wmb();
> -	shared[ref].flags = flags;
> +	gnttab_interface._update_grant_entry(ref, domid, frame,
> flags);
>  }
[snip]

  Paul
